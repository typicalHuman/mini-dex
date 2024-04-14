# IPool
[Git Source](https://github.com/typicalHuman/mini-dex/blob/a516f376e8c6e294135fd4445c6f053c445ae5bd/src\interfaces\IPool.sol)


## Functions
### swap


```solidity
function swap(address token, uint256 amount) external returns (uint256);
```

### deposit


```solidity
function deposit(uint256 amount0, uint256 amount1) external returns (uint256);
```

### withdraw


```solidity
function withdraw(uint256 lpAmount) external returns (uint256, uint256);
```

### quote


```solidity
function quote(address token, uint256 amount) external view returns (uint256);
```

