// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.t.sol";
import {Pool} from "../../src/Pool.sol";
import {MyToken} from "../../src/TestERC20.sol";
import {LP} from "../../src/LP.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC20Test is BaseTest {
    MyToken test_token;
    function setUp() public virtual override {
        BaseTest.setUp();
        vm.startPrank(owner);
        test_token = new MyToken("TEST");
        vm.stopPrank();
    }

    function test_mint() public {
        vm.startPrank(owner);
        uint256 baseMintValue = 10000e18;
        uint256 mintAmount = 1000;
        test_token.mint(owner, mintAmount);
        assertEq(test_token.balanceOf(owner), baseMintValue + mintAmount);
        vm.stopPrank();
    }
}
