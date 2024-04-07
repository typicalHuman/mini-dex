//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// End goal:
// pool with 2 tokens
// ability to swap
// ability to deposit
// ability to withdraw
// ability to quote price of each token
// pool could work by itself, without any external contract


// possible features:
// ability to create pool with native token
// factory check that pool is created by factory

// TODO: foundry tests
// TODO: write fuzz test 
// TODO: write invariat test

import "./LP.sol";
import "./interfaces/IPool.sol";
import "./interfaces/IFactory.sol";
import "./interfaces/IERC20.sol";

// @title Base pool contract 
// @author typicalHuman
contract Pool is IPool, LP {

    uint constant public LP_FEE = 30; // 0.3%
    uint constant public PROTOCOL_FEE = 9; // 1/10 of 0.3%

    address immutable public factory;
    uint public kLast;

    address immutable s_token0;
    address immutable s_token1;
    uint256 public s_reserve0;
    uint256 public s_reserve1;

    error ZERO_ADDRESS();
    error TOKEN_NOT_INSIDE_POOL();
    error AMOUNT_EQUALS_ZERO();
    error INSUFFICIENT_AMOUNT();
    error INSUFFICIENT_BALANCE();
    error TRANSFER_FAILED();
    error NOT_ENOUGH_BALANCE();

    event Swap(address token0, address token1, uint amount0, uint amount1);
    event Deposit(address pool, uint lpAmount, uint amount0, uint amount1);
    event Withdraw(address pool, uint lpAmount, uint amount0, uint amount1);

    constructor(address token0, address token1) LP(string.concat(IERC20(token0).symbol(), IERC20(token1).symbol())){
        if(token0 == address(0) || token1 == address(0))
            revert ZERO_ADDRESS();
        factory = msg.sender;
        s_token0 = token0;
        s_token1 = token1;
    }

    modifier checkTokenInside(address token){
        if(token != s_token0 && token != s_token1) revert TOKEN_NOT_INSIDE_POOL();
        _;
    }

    function swap(address token, uint256 amount) external checkTokenInside(token) returns(uint256 amountOut) {
        address token0 = s_token0;
        address token1 = s_token1;
        if(amount == 0) revert AMOUNT_EQUALS_ZERO();
        amountOut = _quote(token, amount);
        address swap_token = token == token0 ? token1 : token0;
        if(IERC20(swap_token).balanceOf(address(this)) / 2 < amountOut) revert NOT_ENOUGH_BALANCE(); // / 2 so the user couldn't swap half of the pool reserve in 1 swap 
        uint256 amountWithFees = amountOut * LP_FEE / 10000;
        if(swap_token == token0){
            s_reserve0 -= amountOut;
            s_reserve1 += amount;
        }
        else{
            s_reserve0 += amount;
            s_reserve1 -= amountOut;
        }
        emit Swap(swap_token, token, amountWithFees, amountOut);
        _transfer(token, msg.sender, address(this), amount);
        _transfer(swap_token, address(this), msg.sender, amountWithFees);
    }

    function deposit(uint256 amount0, uint256 amount1) external returns(uint256 liquidity){
        uint _totalSupply = totalSupply();
        (uint _reserve0, uint _reserve1) = (s_reserve0, s_reserve1);
        mintFee(_reserve0, _reserve1);
        if(_totalSupply == 0){
            liquidity = sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
            // to prevent over-inflation vulnerability
            _mint(address(0), MINIMUM_LIQUIDITY);
        }else{
            uint256 quotedAmount1 = _quote(s_token0, amount0);
            if(quotedAmount1 < amount1) revert INSUFFICIENT_AMOUNT();
            liquidity = min(amount0 * _totalSupply / _reserve0, amount1 *  _totalSupply / _reserve1);
        }
        _mint(msg.sender, liquidity);
        _reserve0 += amount0;
        _reserve1 += amount1;
        (s_reserve0, s_reserve1) = (_reserve0, _reserve1);
  
        kLast = s_reserve0 * s_reserve1; // maybe check if updating _reserve0 would be cheaper
        emit Deposit(address(this), liquidity, amount0, amount1);
        _transfer(s_token0,  msg.sender,address(this), amount0);
        _transfer(s_token1, msg.sender, address(this),  amount1);
    }

    function withdraw(uint256 lpAmount) external returns (uint256 amount0, uint256 amount1){
        if(balanceOf(msg.sender) < lpAmount) revert INSUFFICIENT_BALANCE();
        (uint _reserve0, uint _reserve1) = (s_reserve0, s_reserve1);
        uint _totalSupply = totalSupply(); 
        amount0 = lpAmount * _reserve0 / _totalSupply;
        amount1 = lpAmount * _reserve1 / _totalSupply;
        if(amount0 == 0 || amount1 == 0) revert INSUFFICIENT_AMOUNT();
        mintFee(_reserve0, _reserve1);
        _burn(address(this), lpAmount);
        _reserve0 -= amount0;
        _reserve1 -= amount1;
        (s_reserve0, s_reserve1) = (_reserve0, _reserve1);
      
        kLast = s_reserve0 * s_reserve1; // maybe check if updating _reserve0 would be cheaper
        emit Withdraw(address(this), lpAmount, amount0, amount1);
        _transfer(s_token0, address(this), msg.sender, amount0);
        _transfer(s_token1, address(this), msg.sender, amount1);
    }

    function quote(address token, uint256 amount) public view checkTokenInside(token) returns(uint256){
        if(amount == 0) revert AMOUNT_EQUALS_ZERO();
        return _quote(token, amount);
    }

    function getTokens() public view returns(address, address){
        return (s_token0, s_token1);
    }

    // fee comes from swaps and not deposits
    // takes 1/10 of swaps fee
    function mintFee(uint _reserve0, uint _reserve1) private{
        address feeTo = IFactory(factory).getProtocolBeneficiary();
        uint _kLast = kLast;
        if(_kLast != 0){
            uint rootK = sqrt(_reserve0 * _reserve1);
            uint rootKLast = sqrt(_kLast);
            if(rootK > rootKLast){
                uint numerator = totalSupply() * (rootK - rootKLast);
                uint denominator = rootK * PROTOCOL_FEE + rootKLast; // check README for math behind that
                uint liquidity = numerator / denominator;
                if(liquidity > 0) _mint(feeTo,liquidity);
            }
        }
    }


    function _quote(address token, uint256 amount) private view returns(uint256){
        address token0 = s_token0;
        uint256 baseReserve = token == token0 ? s_reserve1 : s_reserve0;
        uint256 quoteReserve = token == token0 ? s_reserve0 : s_reserve1;
        return (baseReserve * amount) / quoteReserve;
    }

    function _transfer(address token, address from, address to, uint256 amount) private{
        bool success = IERC20(token).transferFrom(from, to, amount);
        if(!success) revert TRANSFER_FAILED();
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    // slither-disable-start INLINE ASM
    function sqrt(uint256 a) public pure returns (uint256) {
        unchecked {
            if (a <= 1) {
                return a;
            }
            uint256 aa = a;
            uint256 xn = 1;

            if (aa >= (1 << 128)) {
                aa >>= 128;
                xn <<= 64;
            }
            if (aa >= (1 << 64)) {
                aa >>= 64;
                xn <<= 32;
            }
            if (aa >= (1 << 32)) {
                aa >>= 32;
                xn <<= 16;
            }
            if (aa >= (1 << 16)) {
                aa >>= 16;
                xn <<= 8;
            }
            if (aa >= (1 << 8)) {
                aa >>= 8;
                xn <<= 4;
            }
            if (aa >= (1 << 4)) {
                aa >>= 4;
                xn <<= 2;
            }
            if (aa >= (1 << 2)) {
                xn <<= 1;
            }
            xn = (3 * xn) >> 1; // ε_0 := | x_0 - sqrt(a) | ≤ 2**(e-2)
            xn = (xn + a / xn) >> 1; // ε_1 := | x_1 - sqrt(a) | ≤ 2**(e-4.5)  -- special case, see above
            xn = (xn + a / xn) >> 1; // ε_2 := | x_2 - sqrt(a) | ≤ 2**(e-9)    -- general case with k = 4.5
            xn = (xn + a / xn) >> 1; // ε_3 := | x_3 - sqrt(a) | ≤ 2**(e-18)   -- general case with k = 9
            xn = (xn + a / xn) >> 1; // ε_4 := | x_4 - sqrt(a) | ≤ 2**(e-36)   -- general case with k = 18
            xn = (xn + a / xn) >> 1; // ε_5 := | x_5 - sqrt(a) | ≤ 2**(e-72)   -- general case with k = 36
            xn = (xn + a / xn) >> 1; // ε_6 := | x_6 - sqrt(a) | ≤ 2**(e-144)  -- general case with k = 72
            return xn - toUint(xn > a / xn);
        }
    }
 


    function toUint(bool b) internal pure returns (uint256 u) {
        // @solidity memory-safe-assembly
        assembly {
            u := iszero(iszero(b))
        }
    }
    // slither-disable-end INLINE ASM

}

