//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// End goal:
// pool with 2 tokens
// ability to swap
// ability to deposit
// ability to withdraw
// ability to quote price of each token

// possible features:
// ability to create pool with native token
// ability to withdraw/deposit 1 token

import "./LP.sol";

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function symbol() external view returns(string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract Pool is LP {

    //error SENDER_NOT_FACTORY(address sender);
    // modifier onlyFactory{
    //     if(msg.sender != factory)
    //         revert SENDER_NOT_FACTORY(msg.sender);
    //     _;
    // }


    address s_token0;
    address s_token1;
    address public factory;



    constructor(address token0, address token1) LP(string.concat(IERC20(token0).symbol(), IERC20(token1).symbol())){
        factory = msg.sender;
        s_token0 = token0;
        s_token1 = token1;
    }

  

}