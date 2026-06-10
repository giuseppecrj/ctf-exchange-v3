// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// interfaces

// libraries

// contracts

library AuthStorage {
    // keccak256(abi.encode(uint256(keccak256("ctf.auth.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 constant STORAGE_POSITION = 0xedc1f61e78e46695bcdad1b91cef2e8df9fdb3b074121ad238ce6ace56c47300;

    struct Storage {
        uint256 adminCount;
        mapping(address => bool) admins;
        mapping(address => bool) operators;
    }

    function isAdmin(Storage storage $, address caller) internal view returns (bool) {
        return $.admins[caller];
    }

    function isOperator(Storage storage $, address caller) internal view returns (bool) {
        return $.operators[caller];
    }

    function getStorage() internal pure returns (Storage storage $) {
        assembly {
            $.slot := STORAGE_POSITION
        }
    }
}

