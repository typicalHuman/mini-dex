// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {BaseTest} from "../Base.t.sol";
import {console} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.t.sol";
import {Pool} from "../../src/Pool.sol";

contract FactoryTest is BaseTest {
    error TOKENS_NOT_SORTED();
    error POOL_ALREADY_EXISTS();

    address tokenAddress0;
    address tokenAddress1;
    ERC20 token0;
    ERC20 token1;

    function setUp() public virtual override {
        BaseTest.setUp();
        token0 = new ERC20Mock("TEST1", "TEST1", 18);
        token1 = new ERC20Mock("TEST2", "TEST2", 18);
        (tokenAddress0, tokenAddress1) = utils.sortTokens(
            address(token0),
            address(token1)
        );
        token0 = ERC20(tokenAddress0);
        token1 = ERC20(tokenAddress1);
    }

    function test_poolCreation() public {
        Pool _pool = Pool(factory.createPool(tokenAddress0, tokenAddress1));
        (address poolToken0, address poolToken1) = _pool.getTokens();
        assertEq(poolToken0, tokenAddress0);
        assertEq(poolToken1, tokenAddress1);
        assertEq(address(_pool), factory.getPool(tokenAddress0, tokenAddress1));
        assertEq(factory.getProtocolBeneficiary(), owner);
    }

    function test_notSorted() public {
        vm.expectRevert(abi.encodeWithSelector(TOKENS_NOT_SORTED.selector));
        factory.createPool(tokenAddress1, tokenAddress0);
    }

    function test_poolDuplicate() public {
        factory.createPool(tokenAddress0, tokenAddress1);
        vm.expectRevert(abi.encodeWithSelector(POOL_ALREADY_EXISTS.selector));
        factory.createPool(tokenAddress0, tokenAddress1);
    }
}
