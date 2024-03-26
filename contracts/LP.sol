//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "https://github.com/Vectorized/solady/blob/e4a14a5b365b353352f7c38e699a2bc9363d6576/src/tokens/ERC20.sol" ;

contract LP is ERC20 {

    string constant PREFIX = "MINI-";

    uint constant MINIMUM_LIQUIDITY = 10**3;

    string s_name;

    constructor(string memory _name){
        s_name = _name;
        // to prevent over-inflation vulnerability
        _mint(address(0), MINIMUM_LIQUIDITY);
    }

    function name() public view override returns(string memory) {
        return string.concat(PREFIX, s_name);
    }
    function symbol() public view override returns(string memory) {
        return s_name;
    }
}