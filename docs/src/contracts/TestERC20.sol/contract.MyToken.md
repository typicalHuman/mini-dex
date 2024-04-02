# MyToken
[Git Source](https://github.com/typicalHuman/mini-dex/blob/367be2f904fa01431ef0195942219e881b6ff724/contracts\TestERC20.sol)

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

