// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolDepositsTest is BaseTest {
    error INSUFFICIENT_AMOUNT();

    function setUp() public virtual override {
        BaseTest.setUp();
    }

    function test_basicDeposit() public {
        uint token0Amount = 3500e6;
        uint token1Amount = 1e18;
        uint liquidity = depositAmounts(token0Amount, token1Amount, lp);
        uint expectedLiquidity = 59_160_797_830_996 - MINIMUM_LIQUIDITY;
        assertEq(pool.balanceOf(lp), expectedLiquidity);
        assertEq(liquidity, expectedLiquidity);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
        assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 0);
    }
    function test_SecondDeposit() public {
        test_basicDeposit();
        uint token0Amount = 350e6;
        uint token1Amount = 1e17;
        depositAmounts(token0Amount, token1Amount, lp);
        uint expectedLiquidity = 59_160_797_830_996 -
            MINIMUM_LIQUIDITY +
            5_916_079_783_099;
        assertEq(pool.balanceOf(lp), expectedLiquidity);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
        assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 0);
    }

    function test_insufficientAmountDeposit() public {
        vm.expectRevert(abi.encodeWithSelector(INSUFFICIENT_AMOUNT.selector));
        utils.depositAmounts(pool, 0, 0, lp);
    }

    function depositAmounts(
        uint token0Amount,
        uint token1Amount,
        address from
    ) internal returns (uint liquidity) {
        liquidity = utils.depositAmounts(
            pool,
            token0Amount,
            token1Amount,
            from
        );
    }
}
