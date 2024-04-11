//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./Pool.sol";
import "./interfaces/IFactory.sol";

contract Factory is IFactory{
    address immutable s_owner;
    mapping(address => mapping(address => address)) s_pools;
    
    error TOKENS_NOT_SORTED();
    error POOL_ALREADY_EXISTS();

    event PoolCreated(address pool, address token0, address token1);

    constructor(){
        s_owner = msg.sender;
    }

    function createPool(address token0, address token1) external returns (address poolAddress){
        if(token0 >= token1){
            revert TOKENS_NOT_SORTED();
        }
        if(s_pools[token0][token1] != address(0)){
            revert POOL_ALREADY_EXISTS();
        }

        Pool _pool = new Pool(token0, token1);
        poolAddress = address(_pool);
        s_pools[token0][token1] = poolAddress;
        emit PoolCreated(poolAddress, token0, token1);
    }

    function getPool(address token0, address token1) external view returns(address){
        return s_pools[token0][token1];
    }

    function getProtocolBeneficiary() external view returns (address){
        return s_owner;
    }
}