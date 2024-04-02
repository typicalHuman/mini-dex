# LP
[Git Source](https://github.com/typicalHuman/mini-dex/blob/367be2f904fa01431ef0195942219e881b6ff724/contracts\LP.sol)

**Inherits:**
ERC20


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

