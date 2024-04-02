# Pool
[Git Source](https://github.com/typicalHuman/mini-dex/blob/382d298dc7696a779e620a28e91926b08ed66ae4/contracts\Pool.sol)

**Inherits:**
[IPool](/contracts\interfaces\IPool.sol\interface.IPool.md), [LP](/contracts\LP.sol\contract.LP.md)


## State Variables
### LP_FEE

```solidity
uint256 public constant LP_FEE = 30;
```


### PROTOCOL_FEE

```solidity
uint256 public constant PROTOCOL_FEE = 5;
```


### factory

```solidity
address public factory;
```


### kLast

```solidity
uint256 public kLast;
```


### s_token0

```solidity
address s_token0;
```


### s_token1

```solidity
address s_token1;
```


### s_reserve0

```solidity
uint256 s_reserve0;
```


### s_reserve1

```solidity
uint256 s_reserve1;
```


## Functions
### constructor


```solidity
constructor(address token0, address token1) LP(string.concat(IERC20(token0).symbol(), IERC20(token1).symbol()));
```

### checkTokenInside


```solidity
modifier checkTokenInside(address token);
```

### swap


```solidity
function swap(address token, uint256 amount) external checkTokenInside(token) returns (uint256 amountOut);
```

### deposit


```solidity
function deposit(uint256 amount0, uint256 amount1) external returns (uint256 liquidity);
```

### withdraw


```solidity
function withdraw(uint256 lpAmount) external returns (uint256 amount0, uint256 amount1);
```

### quote


```solidity
function quote(address token, uint256 amount) public view checkTokenInside(token) returns (uint256);
```

### mintFee


```solidity
function mintFee(uint256 _reserve0, uint256 _reserve1) private;
```

### _quote


```solidity
function _quote(address token, uint256 amount) private view returns (uint256);
```

### _transfer


```solidity
function _transfer(address token, address from, address to, uint256 amount) private;
```

### min


```solidity
function min(uint256 a, uint256 b) internal pure returns (uint256);
```

### sqrt


```solidity
function sqrt(uint256 a) public pure returns (uint256);
```

### toUint


```solidity
function toUint(bool b) internal pure returns (uint256 u);
```

## Events
### Swap

```solidity
event Swap(address token0, address token1, uint256 amount0, uint256 amount1);
```

### Deposit

```solidity
event Deposit(address pool, uint256 lpAmount, uint256 amount0, uint256 amount1);
```

### Withdraw

```solidity
event Withdraw(address pool, uint256 lpAmount, uint256 amount0, uint256 amount1);
```

## Errors
### TOKEN_NOT_INSIDE_POOL

```solidity
error TOKEN_NOT_INSIDE_POOL();
```

### AMOUNT_EQUALS_ZERO

```solidity
error AMOUNT_EQUALS_ZERO();
```

### INSUFFICIENT_AMOUNT

```solidity
error INSUFFICIENT_AMOUNT();
```

### INSUFFICIENT_BALANCE

```solidity
error INSUFFICIENT_BALANCE();
```

### TRANSFER_FAILED

```solidity
error TRANSFER_FAILED();
```

### NOT_ENOUGH_BALANCE

```solidity
error NOT_ENOUGH_BALANCE();
```

