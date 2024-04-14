# IERC20
[Git Source](https://github.com/typicalHuman/mini-dex/blob/acf28f18c2b98843f4a08cee3d9a411c878cfb3c/src\interfaces\IERC20.sol)


## Functions
### totalSupply


```solidity
function totalSupply() external view returns (uint256);
```

### symbol


```solidity
function symbol() external view returns (string memory);
```

### balanceOf


```solidity
function balanceOf(address account) external view returns (uint256);
```

### transfer


```solidity
function transfer(address to, uint256 value) external returns (bool);
```

### allowance


```solidity
function allowance(address owner, address spender) external view returns (uint256);
```

### approve


```solidity
function approve(address spender, uint256 value) external returns (bool);
```

### transferFrom


```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool);
```

## Events
### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 value);
```

### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 value);
```

