//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IFactory{
    function getProtocolBeneficiary() external view returns (address);
}