// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces

// libraries

// contracts

library AssetsStorage {
    // keccak256(abi.encode(uint256(keccak256("ctf.assets.base.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 constant STORAGE_POSITION = 0x807ae90594f3895b02cd196bbdfd5b24edeca5bfef1775e21a6c9d6654361000;

    struct Storage {
        address collateral;
        address ctf;
        address ctfCollateral;
        address outcomeTokenFactory;
    }

    function getCtfCollateral(Storage storage $) internal view returns (address) {
        return $.ctfCollateral;
    }

    function getStorage() internal pure returns (Storage storage $) {
        assembly {
            $.slot := STORAGE_POSITION
        }
    }
}
