// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.t.sol";
import {Pool} from "../../src/Pool.sol";
import {LP} from "../../src/LP.sol";

contract LPTest is BaseTest {
    function setUp() public virtual override {
        BaseTest.setUp();
    }

    function test_displayData() public {
        LP lpToken = new LP("Pool");
        assertEq(lpToken.name(), "MINI-Pool");
        assertEq(lpToken.symbol(), "Pool");
    }
}
