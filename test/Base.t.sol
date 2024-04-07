// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {ERC20Mock} from "./mocks/ERC20Mock.sol";
import {Factory} from "../src/Factory.sol";
import {Pool} from "../src/Pool.sol";
import {Utilities} from "./utils/Utilities.sol";
contract BaseTest is Test {

    uint constant MINIMUM_LIQUIDITY = 10**3;
    uint constant INITIAL_USDT_BALANCE = 10000e6;
    uint constant INITIAL_WETH_BALANCE = 100e18;

    ERC20Mock public usdt;
    address public usdtAddress;

    ERC20Mock public weth;
    address public wethAddress;

    Factory public factory;
    Pool public pool;

    Utilities internal utils;
    
    address public owner = vm.addr(1);
    address public lp = vm.addr(2);
    address public randUser = vm.addr(50);

    function setUp() public virtual{
        utils = new Utilities();

        _setUpMocks();
        _labelContracts();
    }

    function _setUpMocks() internal{
        usdt = new ERC20Mock("USDT", "USDT", 6);
        weth = new ERC20Mock("WETH", "WETH", 6);
        usdtAddress = address(usdt);
        wethAddress = address(weth);

        vm.deal(lp, 100 ether);
        usdt.mint(lp, INITIAL_USDT_BALANCE);
        weth.mint(lp, INITIAL_WETH_BALANCE);

        vm.prank(owner);
        factory = new Factory();


        vm.startPrank(lp);
        address token0 = usdtAddress > wethAddress ? wethAddress : usdtAddress;
        address token1 = usdtAddress > wethAddress ? usdtAddress : wethAddress;
        pool = Pool(factory.createPool(token0, token1));
    }
    
    function _labelContracts() internal{
        vm.label(address(weth), "WETH");
        vm.label(address(usdt), "USDT");
        vm.label(address(pool), "[WETH/USDT]");
        vm.label(lp, "LP");
        vm.label(owner, "OWNER");
        vm.label(address(factory), "FACTORY");
    }

    // add this to be excluded from coverage report
    function test() public {}
}
