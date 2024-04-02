# Factory
[Git Source](https://github.com/typicalHuman/mini-dex/blob/382d298dc7696a779e620a28e91926b08ed66ae4/contracts\Factory.sol)


## State Variables
### s_owner

```solidity
address s_owner;
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


```solidity
function createPool(address token0, address token1) external returns (address poolAddress);
```

### getPool


```solidity
function getPool(address token0, address token1) external view returns (address);
```

### getProtocolBeneficiary


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

### TOKENS_ARE_DUPLICATES

```solidity
error TOKENS_ARE_DUPLICATES();
```

### POOL_ALREADY_EXISTS

```solidity
error POOL_ALREADY_EXISTS();
```

