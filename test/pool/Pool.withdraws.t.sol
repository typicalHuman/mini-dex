// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolWithdrawsTest is BaseTest {
    error INSUFFICIENT_AMOUNT();
    error INSUFFICIENT_BALANCE();

    function setUp() public virtual override {
        BaseTest.setUp();
    }

    function test_basicWithdraw() public {
        uint token0Amount = 3500e6;
        uint token1Amount = 1e18;
        uint liquidity = utils.depositAmounts(
            pool,
            token0Amount,
            token1Amount,
            lp
        );
        (address _token0, address _token1) = pool.getTokens();
        (ERC20 token0, ERC20 token1) = (ERC20(_token0), ERC20(_token1));
        uint balance0 = (liquidity * token0.balanceOf(address(pool))) /
            pool.totalSupply();
        uint balance1 = (liquidity * token1.balanceOf(address(pool))) /
            pool.totalSupply();
        (uint withdrewAmount0, uint withdrewAmount1) = utils.withdrawAmounts(
            pool,
            liquidity,
            lp
        );
        // because we have MINIMUM_LIQUIDITY withdrew amount won't be the exact same
        assertApproxEqAbs(token0Amount, withdrewAmount0, balance0);
        assertApproxEqAbs(token1Amount, withdrewAmount1, balance1);
        assertEq(pool.totalSupply(), MINIMUM_LIQUIDITY);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
    }

    function test_insufficientBalanceWithdraw() public {
        vm.expectRevert(abi.encodeWithSelector(INSUFFICIENT_BALANCE.selector));
        utils.withdrawAmounts(pool, 10, owner);
    }
    function test_insufficientAmountWithdraw() public {
        uint token0Amount = 3500e6;
        uint token1Amount = 1e18;
        utils.depositAmounts(
            pool,
            token0Amount,
            token1Amount,
            lp
        );
        vm.expectRevert(abi.encodeWithSelector(INSUFFICIENT_AMOUNT.selector));
        utils.withdrawAmounts(pool, 0, lp);
    }
}
