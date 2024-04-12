// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";


// Contract for remix manual testing
contract MyToken is ERC20, Ownable, ERC20Permit {
    constructor(string memory symbol)
        ERC20(symbol, symbol)
        Ownable(msg.sender)
        ERC20Permit(symbol)
    {
        mint(msg.sender, 10000e18);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
