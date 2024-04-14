# LP
[Git Source](https://github.com/typicalHuman/mini-dex/blob/17a070a04b17f7bc8f83d8447e027f6a248e4a0c/src\LP.sol)

**Inherits:**
ERC20

**Author:**
typicalHuman.

Represents pool shares.


## State Variables
### PREFIX

```solidity
string constant PREFIX = "MINI-";
```


### MINIMUM_LIQUIDITY

```solidity
uint256 constant MINIMUM_LIQUIDITY = 10 ** 3;
```


### s_name

```solidity
string s_name;
```


## Functions
### constructor


```solidity
constructor(string memory _name);
```

### name


```solidity
function name() public view override returns (string memory);
```

### symbol


```solidity
function symbol() public view override returns (string memory);
```

