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
    // add this to be excluded from coverage report
    function test() public {}
}