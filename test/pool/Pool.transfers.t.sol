// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;
// import {BaseTest} from "../Base.t.sol";
// import {console} from "forge-std/Test.sol";
// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract PoolTransfersTest is BaseTest {
//     Pool testPool;
//     address tokenAddress0;
//     address tokenAddress1;
//     function setUp() public virtual override {
//         BaseTest.setUp();
//         token0 = new ERC20Mock("TEST1", "TEST1", 18);
//         token1 = new ERC20Mock("TEST2", "TEST2", 18);
//         (tokenAddress0, tokenAddress1) = utils.sortTokens(
//             address(token0),
//             address(token1)
//         );
//         token0 = ERC20(tokenAddress0);
//         token1 = ERC20(tokenAddress1);
//         testPool = Pool(factory.createPool(tokenAddress0, tokenAddress1));
//     }
// }
