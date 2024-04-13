// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolProtocolFeeTest is BaseTest {
    function setUp() public virtual override {
        BaseTest.setUp();
        utils.depositAmounts(pool, 100000e6, 100 ether, lp);
    }

    function test_MintFee() public {
        vm.startPrank(lp);
        console.log(pool.s_reserve0()* pool.s_reserve1());
        utils.swapAmount(pool, poolToken0, 40e6, lp);
        console.log(pool.s_reserve0()* pool.s_reserve1());
        uint amount0 = 20e6;
        uint amount1 = pool.quote(poolToken0, amount0);
        utils.depositAmounts(pool, amount0, amount1, lp);
        console.log(pool.balanceOf(factory.getProtocolBeneficiary())); // first protocol fee
        vm.stopPrank();
    }
}
