//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./Pool.sol";

contract Factory{

    error TOKENS_NOT_SORTED();
    error TOKENS_ARE_DUPLICATES();
    error POOL_ALREADY_EXISTS();

    address s_owner;
    mapping(address => mapping(address => address)) s_pools;
    
    constructor(){
        s_owner = msg.sender;
    }

    function createPool(address token0, address token1) external{
        if(token0 > token1){
            revert TOKENS_NOT_SORTED();
        }
        if(token0 == token1){
            revert TOKENS_ARE_DUPLICATES();
        }
        if(s_pools[token0][token1] != address(0)){
            revert POOL_ALREADY_EXISTS();
        }

        Pool _pool = new Pool(token0, token1);
        s_pools[token0][token1] = address(_pool);
    }




    function getPool(address token0, address token1) external view returns(address){
        return s_pools[token0][token1];
    }
}