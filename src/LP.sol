//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "solady/tokens/ERC20.sol";

/// @title Base token for Pool.
/// @author typicalHuman.
/// @notice Represents pool shares.
contract LP is ERC20 {
    string constant PREFIX = "MINI-";

    uint constant MINIMUM_LIQUIDITY = 10 ** 3;

    string s_name;

    constructor(string memory _name) {
        s_name = _name;
    }

    function name() public view override returns (string memory) {
        return string.concat(PREFIX, s_name);
    }
    function symbol() public view override returns (string memory) {
        return s_name;
    }
}
