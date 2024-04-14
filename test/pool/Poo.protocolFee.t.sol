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

    //  reserve before swap - 10000000000000000000000000000000^(1/2) = 3,162,277,660,168,379.3319988935444327
    //  reserve after swap - 10000010395200000000000000000000^(1/2) - 3,162,279,303,793,388.8359592717093679

    // 3,162,279,303,793,388.8359592717093679-3,162,277,660,168,379.3319988935444327 = 1,643,625,009.5039603781649352 * total_shares(3162277660168379) = 5,197,598,649,248,413,520,871,393.7228227
    // ------------------------------------------------------------------------------
    // 9*3,162,279,303,793,388.8359592717093679 + 3,162,277,660,168,379.3319988935444327 = 31,622,791,394,308,878.855632338928744

    // protocol fee = 5,197,598,649,248,413,520,871,393.7228227 / 31,622,791,394,308,878.855632338928744 = 164,362,424.06430382321667141919915
    function test_MintFee() public {
        utils.swapAmount(pool, poolToken0, 40e6, lp);
        uint amount0 = 20e6;
        uint amount1 = pool.quote(poolToken0, amount0);
        utils.depositAmounts(pool, amount0, amount1, lp);
        assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 164_362_424);
    }
}
