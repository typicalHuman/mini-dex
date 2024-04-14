# Factory
[Git Source](https://github.com/typicalHuman/mini-dex/blob/acf28f18c2b98843f4a08cee3d9a411c878cfb3c/src\Factory.sol)

**Inherits:**
[IFactory](/src\interfaces\IFactory.sol\interface.IFactory.md)

**Author:**
typicalHuman.

Factory should be single instance for UX (finding pools for different tokens and for possible routing).


## State Variables
### s_owner

```solidity
address immutable s_owner;
```


### s_pools

```solidity
mapping(address => mapping(address => address)) s_pools;
```


## Functions
### constructor


```solidity
constructor();
```

### createPool

Create new pool with 2 assets.

*Pool should be unique (pool with these assets shouldn't be used on this factory yet).*


```solidity
function createPool(address token0, address token1) external returns (address poolAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token0`|`address`|First asset of the pool.|
|`token1`|`address`|Second asset of the pool.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`poolAddress`|`address`|Address of newly created pool.|


### getPool

Get pool address based on assets.

*The order matters.*


```solidity
function getPool(address token0, address token1) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token0`|`address`|First asset of the pool.|
|`token1`|`address`|Second asset of the pool.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Address of the pool, if not found - returns zero address.|


### getProtocolBeneficiary

Get address which will receive protocol fees.


```solidity
function getProtocolBeneficiary() external view returns (address);
```

## Events
### PoolCreated

```solidity
event PoolCreated(address pool, address token0, address token1);
```

## Errors
### TOKENS_NOT_SORTED

```solidity
error TOKENS_NOT_SORTED();
```

### POOL_ALREADY_EXISTS

```solidity
error POOL_ALREADY_EXISTS();
```

