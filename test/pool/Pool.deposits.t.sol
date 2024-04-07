
import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PoolDepositsTest is BaseTest{
    function setUp() public virtual override {
        BaseTest.setUp();
    }

    function test_basicDeposit() public{
        uint token0Amount = 3500e6;
        uint token1Amount = 1e18;
        depositAmounts(token0Amount, token1Amount, lp);
        uint expectedLiquidity = 59_160_797_830_996 - MINIMUM_LIQUIDITY;
        assertEq(pool.balanceOf(lp), expectedLiquidity);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
        assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 0);
    }
    function test_SecondDeposit() public{
        test_basicDeposit();
        uint token0Amount = 350e6;
        uint token1Amount = 1e17;
        depositAmounts(token0Amount, token1Amount, lp);
        uint expectedLiquidity = 59_160_797_830_996 - MINIMUM_LIQUIDITY + 5_916_079_783_099;
        assertEq(pool.balanceOf(lp), expectedLiquidity);
        assertEq(pool.balanceOf(address(0)), MINIMUM_LIQUIDITY);
        assertEq(pool.balanceOf(factory.getProtocolBeneficiary()), 0);
    }


    function depositAmounts(uint token0Amount, uint token1Amount, address from) internal returns (uint liquidity){
       utils.depositAmounts(pool, token0Amount, token1Amount, from);
    }
}