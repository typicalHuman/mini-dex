# MyToken
[Git Source](https://github.com/typicalHuman/mini-dex/blob/acf28f18c2b98843f4a08cee3d9a411c878cfb3c/src\TestERC20.sol)

**Inherits:**
ERC20, Ownable, ERC20Permit


## Functions
### constructor


```solidity
constructor(string memory symbol) ERC20(symbol, symbol) Ownable(msg.sender) ERC20Permit(symbol);
```

### mint


```solidity
function mint(address to, uint256 amount) public onlyOwner;
```

