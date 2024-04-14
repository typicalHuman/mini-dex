//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./Pool.sol";
import "./interfaces/IFactory.sol";

/// @title Factory contract to deploy new pools.
/// @author typicalHuman.
/// @notice Factory should be single instance for UX (finding pools for different tokens and for possible routing).
contract Factory is IFactory {
    address immutable s_owner;
    mapping(address => mapping(address => address)) s_pools;

    error TOKENS_NOT_SORTED();
    error POOL_ALREADY_EXISTS();

    event PoolCreated(address pool, address token0, address token1);

    constructor() {
        s_owner = msg.sender;
    }

    /// @notice Create new pool with 2 assets.
    /// @dev Pool should be unique (pool with these assets shouldn't be used on this factory yet).
    /// @param token0 First asset of the pool.
    /// @param token1 Second asset of the pool.
    /// @return poolAddress Address of newly created pool.
    function createPool(
        address token0,
        address token1
    ) external returns (address poolAddress) {
        if (token0 >= token1) {
            revert TOKENS_NOT_SORTED();
        }
        if (s_pools[token0][token1] != address(0)) {
            revert POOL_ALREADY_EXISTS();
        }

        Pool _pool = new Pool(token0, token1);
        poolAddress = address(_pool);
        s_pools[token0][token1] = poolAddress;
        emit PoolCreated(poolAddress, token0, token1);
    }

    /// @notice Get pool address based on assets.
    /// @dev The order matters.
    /// @param token0 First asset of the pool.
    /// @param token1 Second asset of the pool.
    /// @return Address of the pool, if not found - returns zero address.
    function getPool(
        address token0,
        address token1
    ) external view returns (address) {
        return s_pools[token0][token1];
    }

    /// @notice Get address which will receive protocol fees.
    function getProtocolBeneficiary() external view returns (address) {
        return s_owner;
    }
}
