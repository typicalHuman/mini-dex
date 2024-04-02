# MyToken
[Git Source](https://github.com/typicalHuman/mini-dex/blob/382d298dc7696a779e620a28e91926b08ed66ae4/contracts\TestERC20.sol)

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

