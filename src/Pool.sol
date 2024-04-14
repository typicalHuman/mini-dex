//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// End goal:
// pool with 2 tokens
// ability to swap
// ability to deposit
// ability to withdraw
// ability to quote price of each token
// pool could work by itself, without any external contract

import "./LP.sol";
import "./interfaces/IPool.sol";
import "./interfaces/IFactory.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// @title Base pool contract
// @author typicalHuman
contract Pool is IPool, LP {
    using SafeERC20 for IERC20;
    using Math for uint;
    uint public constant LP_FEE = 30; // 0.3%
    uint public constant PROTOCOL_FEE = 9; // 1/10 of 0.3%

    address public immutable factory;
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

    constructor(
        address token0,
        address token1
    ) LP(string.concat(ERC20(token0).symbol(), ERC20(token1).symbol())) {
        if (token0 == address(0) || token1 == address(0)) revert ZERO_ADDRESS();
        factory = msg.sender;
        s_token0 = token0;
        s_token1 = token1;
    }

    modifier checkTokenInside(address token) {
        if (token != s_token0 && token != s_token1)
            revert TOKEN_NOT_INSIDE_POOL();
        _;
    }

    function swap(
        address token,
        uint256 amount
    ) external checkTokenInside(token) returns (uint256 amountOut) {
        if (amount == 0) revert AMOUNT_EQUALS_ZERO();
        if (amount > IERC20(token).balanceOf(msg.sender))
            revert INSUFFICIENT_BALANCE();
        address token0 = s_token0;
        address token1 = s_token1;
        amountOut = _quote(token, amount);
        address swap_token = token == token0 ? token1 : token0;
        if (IERC20(swap_token).balanceOf(address(this)) / 2 < amountOut)
            revert NOT_ENOUGH_BALANCE(); // / 2 so the user couldn't swap half of the pool reserve in 1 swap
        uint256 amountWithFees = amount + (amount * LP_FEE) / 10000;
        if (swap_token == token0) {
            s_reserve0 -= amountOut;
            s_reserve1 += amountWithFees;
        } else {
            s_reserve0 += amountWithFees;
            s_reserve1 -= amountOut;
        }
        emit Swap(swap_token, token, amountWithFees, amountOut);
        p_transferFrom(token, msg.sender, address(this), amountWithFees);
        p_transfer(swap_token, msg.sender, amountOut);
    }

    function deposit(
        uint256 amount0,
        uint256 amount1
    ) external returns (uint256 liquidity) {
        if (amount0 == 0 || amount1 == 0) revert INSUFFICIENT_AMOUNT();
        uint _totalSupply = totalSupply();
        (uint _reserve0, uint _reserve1) = (s_reserve0, s_reserve1);
        mintFee(_reserve0, _reserve1);
        if (_totalSupply == 0) {
            liquidity = (amount0 * amount1).sqrt() - MINIMUM_LIQUIDITY;
            // to prevent over-inflation vulnerability
            _mint(address(0), MINIMUM_LIQUIDITY);
        } else {
            uint256 quotedAmount1 = _quote(s_token0, amount0);
            if (quotedAmount1 < amount1) revert INSUFFICIENT_AMOUNT();
            liquidity = ((amount0 * _totalSupply) / _reserve0).min(
                (amount1 * _totalSupply) / _reserve1
            );
        }
        _mint(msg.sender, liquidity);
        _reserve0 += amount0;
        _reserve1 += amount1;
        (s_reserve0, s_reserve1) = (_reserve0, _reserve1);

        kLast = _reserve0 * _reserve1;
        emit Deposit(address(this), liquidity, amount0, amount1);
        p_transferFrom(s_token0, msg.sender, address(this), amount0);
        p_transferFrom(s_token1, msg.sender, address(this), amount1);
    }

    function withdraw(
        uint256 lpAmount
    ) external returns (uint256 amount0, uint256 amount1) {
        uint _totalSupply = totalSupply();
        if (balanceOf(msg.sender) < lpAmount || _totalSupply == 0)
            revert INSUFFICIENT_BALANCE();
        p_transferFrom(address(this), msg.sender, address(this), lpAmount);
        (uint _reserve0, uint _reserve1) = (s_reserve0, s_reserve1);
        amount0 = (lpAmount * _reserve0) / _totalSupply;
        amount1 = (lpAmount * _reserve1) / _totalSupply;
        if (amount0 == 0 || amount1 == 0) revert INSUFFICIENT_AMOUNT();
        mintFee(_reserve0, _reserve1);
        _burn(address(this), lpAmount);
        _reserve0 -= amount0;
        _reserve1 -= amount1;
        (s_reserve0, s_reserve1) = (_reserve0, _reserve1);

        kLast = _reserve0 * _reserve1;
        emit Withdraw(address(this), lpAmount, amount0, amount1);
        p_transfer(s_token0, msg.sender, amount0);
        p_transfer(s_token1, msg.sender, amount1);
    }

    function quote(
        address token,
        uint256 amount
    ) public view checkTokenInside(token) returns (uint256) {
        if (amount == 0) revert AMOUNT_EQUALS_ZERO();
        return _quote(token, amount);
    }

    function getTokens() public view returns (address, address) {
        return (s_token0, s_token1);
    }

    // fee comes from swaps and not deposits
    // takes 1/10 of swaps fee
    function mintFee(uint _reserve0, uint _reserve1) private {
        address feeTo = IFactory(factory).getProtocolBeneficiary();
        uint _kLast = kLast;
        if (_kLast != 0) {
            uint rootK = (_reserve0 * _reserve1).sqrt();
            uint rootKLast = _kLast.sqrt();
            if (rootK > rootKLast) {
                uint numerator = totalSupply() * (rootK - rootKLast);
                uint denominator = rootK * PROTOCOL_FEE + rootKLast; // check README for math behind that
                uint liquidity = numerator / denominator;
                if (liquidity > 0) _mint(feeTo, liquidity);
            }
        }
    }

    function _quote(
        address token,
        uint256 amount
    ) private view returns (uint256) {
        address token0 = s_token0;
        uint256 baseReserve = token == token0 ? s_reserve1 : s_reserve0;
        uint256 quoteReserve = token == token0 ? s_reserve0 : s_reserve1;
        return (baseReserve * amount) / quoteReserve;
    }

    function p_transferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    ) private {
        IERC20(token).safeTransferFrom(from, to, amount);
    }
    function p_transfer(address token, address to, uint256 amount) private {
        IERC20(token).safeTransfer(to, amount);
    }
}
