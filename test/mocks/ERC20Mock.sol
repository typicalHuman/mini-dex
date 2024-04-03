// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mock is ERC20 {
    uint8 internal immutable  _decimals;
    
    constructor(string memory __name, string memory __symbol, uint8 __decimals) ERC20(__name, __symbol) {
        _decimals = __decimals;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
    function decimals() public override view returns(uint8){
        return _decimals;
    }
}