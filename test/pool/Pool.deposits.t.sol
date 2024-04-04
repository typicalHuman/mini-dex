
import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolDepositsTest is BaseTest{
    function setUp() public virtual override {
        BaseTest.setUp();
    }

    function test_basicDeposit() public{
        uint token0Amount = 1e18;
        uint token1Amount = 3500e6;
        uint liquidity = depositAmounts(token0Amount, token1Amount, lp);
        uint expectedLiquidity = 59_160_797_830_996 - MINIMUM_LIQUIDITY;
        assertEq(expectedLiquidity, expectedLiquidity);
        assertEq(pool.balanceOf(lp), expectedLiquidity);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
        assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 0);
    }
    function test_SecondDeposit() public{
        test_basicDeposit();
        uint token0Amount = 1e17;
        uint token1Amount = 350e6;
        uint liquidity = depositAmounts(token0Amount, token1Amount, lp);
        console.log("LIQUIDITY", liquidity);
        uint expectedLiquidity = 59_160_797_830_996 - MINIMUM_LIQUIDITY + 5_916_079_783_099;
        assertEq(expectedLiquidity, expectedLiquidity);
        assertEq(pool.balanceOf(lp), expectedLiquidity);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
        console.log("KLAST ", pool.kLast());
        console.log("BENEFICIARY BALANCE", pool.balanceOf(factory.getProtocolBeneficiary()));
       // assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 0);
    }


    function depositAmounts(uint token0Amount, uint token1Amount, address from) internal returns (uint liquidity){
        vm.startPrank(from);
        weth.approve(address(pool), token0Amount);
        usdt.approve(address(pool), token1Amount);
        liquidity = pool.deposit(token0Amount, token1Amount);
        vm.stopPrank();
    }
}