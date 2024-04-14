// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolSwapsTest is BaseTest {
    error INSUFFICIENT_BALANCE();
    error NOT_ENOUGH_BALANCE();
    error AMOUNT_EQUALS_ZERO();
    function setUp() public virtual override {
        BaseTest.setUp();
        utils.depositAmounts(pool, 100e6, 1 ether, lp);
    }

    function test_swap0Base() public {
        uint toSwapAmount = 10e6;
        uint expectedAmount = pool.quote(poolToken0, toSwapAmount);
        (uint beforeSwapBalance0, uint beforeSwapBalance1) = (
            ERC20(poolToken0).balanceOf(lp),
            ERC20(poolToken1).balanceOf(lp)
        );
        uint amountReceived = utils.swapAmount(
            pool,
            poolToken0,
            toSwapAmount,
            lp
        );
        uint expectedAfterBalance0 = beforeSwapBalance0 -
            utils.amountWFee(pool, toSwapAmount);
        uint expectedAfterBalance1 = beforeSwapBalance1 + expectedAmount;
        assertEq(expectedAmount, amountReceived);
        assertEq(expectedAfterBalance0, ERC20(poolToken0).balanceOf(lp));
        assertEq(expectedAfterBalance1, ERC20(poolToken1).balanceOf(lp));
    }
    function test_swap1Base() public {
        uint toSwapAmount = 1e17;
        uint expectedAmount = pool.quote(poolToken1, toSwapAmount);
        (uint beforeSwapBalance0, uint beforeSwapBalance1) = (
            ERC20(poolToken0).balanceOf(lp),
            ERC20(poolToken1).balanceOf(lp)
        );
        uint amountReceived = utils.swapAmount(
            pool,
            poolToken1,
            toSwapAmount,
            lp
        );
        uint expectedAfterBalance1 = beforeSwapBalance1 -
            utils.amountWFee(pool, toSwapAmount);
        uint expectedAfterBalance0 = beforeSwapBalance0 + expectedAmount;
        assertEq(expectedAmount, amountReceived);
        assertEq(expectedAfterBalance0, ERC20(poolToken0).balanceOf(lp));
        assertEq(expectedAfterBalance1, ERC20(poolToken1).balanceOf(lp));
    }

    function test_insufficientAmount() public {
        vm.expectRevert(abi.encodeWithSelector(AMOUNT_EQUALS_ZERO.selector));
        pool.swap(poolToken0, 0);
    }
    function test_insufficientBalance() public {
        vm.expectRevert(abi.encodeWithSelector(INSUFFICIENT_BALANCE.selector));
        pool.swap(poolToken0, 1 ether);
    }

    function test_notEnoughBalance() public {
        vm.expectRevert(abi.encodeWithSelector(NOT_ENOUGH_BALANCE.selector));
        utils.swapAmount(pool, poolToken0, 200e6, lp);
    }
}
