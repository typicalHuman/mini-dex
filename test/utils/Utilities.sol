// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Pool} from "../../src/Pool.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Utilities is Test{

    function depositAmounts(Pool pool, uint token0Amount, uint token1Amount, address from) public returns (uint liquidity){
        (address token0Address, address token1Address) = pool.getTokens();
        (ERC20 token0, ERC20 token1) = (ERC20(token0Address), ERC20(token1Address));
        vm.startPrank(from);
        token0.approve(address(pool), token0Amount);
        token1.approve(address(pool), token1Amount);
        liquidity = pool.deposit(token0Amount, token1Amount);
        vm.stopPrank();
    }
    function withdrawAmounts(Pool pool, uint lpAmount, address from) public returns (uint amount0, uint amount1){
        vm.startPrank(from);
        pool.approve(address(pool), lpAmount);
        (amount0, amount1) = pool.withdraw(lpAmount);
        vm.stopPrank();
    }

    function sortTokens(address token0, address token1) public pure returns (address tokenAddress0, address tokenAddress1){
        tokenAddress0 = token0 > token1 ? token1 : token0;
        tokenAddress1 = token0 > token1 ? token0 : token1;
    }
    // add this to be excluded from coverage report
    function test() public {}
}