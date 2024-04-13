// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolQuoteTest is BaseTest {
    error TOKEN_NOT_INSIDE_POOL();
    error AMOUNT_EQUALS_ZERO();
    function setUp() public virtual override {
        BaseTest.setUp();
        utils.depositAmounts(pool, 100e6, 1 ether, lp);
    }

    function test_quoteBase() public view{
        uint quote0 = pool.quote(poolToken0, 10e6);
        assertEq(quote0, 1e17);
    }
    function test_InvalidToken() public {
        vm.expectRevert(abi.encodeWithSelector(TOKEN_NOT_INSIDE_POOL.selector));
        pool.quote(address(0), 10e6);
    }
    function test_InvalidAmount() public {
        vm.expectRevert(abi.encodeWithSelector(AMOUNT_EQUALS_ZERO.selector));
        pool.quote(poolToken0, 0);
    }
}
