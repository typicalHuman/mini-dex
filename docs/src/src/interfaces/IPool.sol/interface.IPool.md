# IPool
[Git Source](https://github.com/typicalHuman/mini-dex/blob/acf28f18c2b98843f4a08cee3d9a411c878cfb3c/src\interfaces\IPool.sol)


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

