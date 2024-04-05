//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


interface IPool{
    function swap(address token, uint256 amount) external returns(uint256);
    function deposit(uint256 amount0, uint256 amount1) external returns(uint256);
    function withdraw(uint256 lpAmount) external returns (uint256, uint256);
    function quote(address token, uint256 amount) external view returns(uint256);
}