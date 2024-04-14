# Pool
[Git Source](https://github.com/typicalHuman/mini-dex/blob/17a070a04b17f7bc8f83d8447e027f6a248e4a0c/src\Pool.sol)

**Inherits:**
[IPool](/src\interfaces\IPool.sol\interface.IPool.md), [LP](/src\LP.sol\contract.LP.md)

**Author:**
typicalHuman

Contract that allows you to stake/swap 2 assets.


## State Variables
### LP_FEE

```solidity
uint256 public constant LP_FEE = 30;
```


### PROTOCOL_FEE

```solidity
uint256 public constant PROTOCOL_FEE = 9;
```


### factory

```solidity
address public immutable factory;
```


### kLast

```solidity
uint256 public kLast;
```


### s_token0

```solidity
address immutable s_token0;
```


### s_token1

```solidity
address immutable s_token1;
```


### s_reserve0

```solidity
uint256 public s_reserve0;
```


### s_reserve1

```solidity
uint256 public s_reserve1;
```


## Functions
### constructor

Initializes pool.

*Tokens should be sorted in asc order.*


```solidity
constructor(address token0, address token1) LP(string.concat(ERC20(token0).symbol(), ERC20(token1).symbol()));
```

### checkTokenInside


```solidity
modifier checkTokenInside(address token);
```

### swap

Swap 1 token to another.

*Token amount shouldn't be bigger than half of pool reserve.*


```solidity
function swap(address token, uint256 amount) external checkTokenInside(token) returns (uint256 amountOut);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|Input token.|
|`amount`|`uint256`|Input token amount.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amountOut`|`uint256`|Amount out in second token.|


### deposit

Stake tokens in pool

*If total supply is 0, it will mint MINIMUM_LIQUIDITY to prevent inflation attack*


```solidity
function deposit(uint256 amount0, uint256 amount1) external returns (uint256 liquidity);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|First token amount to stake|
|`amount1`|`uint256`|Second token amount to stake|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`liquidity`|`uint256`|Liquidity minted after stake. It will represent your share in this pool.|


### withdraw

Unstake shares back to tokens.

*You can't withdraw your shares into only 1 one of the tokens.*


```solidity
function withdraw(uint256 lpAmount) external returns (uint256 amount0, uint256 amount1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`lpAmount`|`uint256`|Shares amount to withdraw.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`amount0`|`uint256`|Amount in token0 that was unstaked.|
|`amount1`|`uint256`|Amount in token1 that was unstaked.|


### quote

Get relative price in the second token.

*Pool can't be empty (totalSupply should be bigger than 0).*


```solidity
function quote(address token, uint256 amount) public view checkTokenInside(token) returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`token`|`address`|Base token for which you want to quote the price.|
|`amount`|`uint256`|Amount to quote in "token".|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|Relative price in second token.|


### getTokens


```solidity
function getTokens() public view returns (address, address);
```

### mintFee

Fee comes from swaps and not deposits

*Takes 1/10 of swaps fee*


```solidity
function mintFee(uint256 _reserve0, uint256 _reserve1) private;
```

### _quote


```solidity
function _quote(address token, uint256 amount) private view returns (uint256);
```

### p_transferFrom


```solidity
function p_transferFrom(address token, address from, address to, uint256 amount) private;
```

### p_transfer


```solidity
function p_transfer(address token, address to, uint256 amount) private;
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
### ZERO_ADDRESS

```solidity
error ZERO_ADDRESS();
```

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

