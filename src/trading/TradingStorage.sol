// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces

// libraries

// contracts
import { OrderStatus } from "../Structs.sol";

library TradingStorage {
    // keccak256(abi.encode(uint256(keccak256("ctf.trading.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 constant STORAGE_POSITION = 0x5314184f24b0cea768fd7914a4b8bc43ffdf5b35d65b7e7028058d7e5b277a00;

    struct Storage {
        mapping(bytes32 => OrderStatus) orderStatus;
        mapping(bytes32 => bool) preApproved;
    }

    function getOrderStatus(Storage storage $, bytes32 orderHash) internal view returns (OrderStatus memory) {
        return $.orderStatus[orderHash];
    }

    function isPreapproved(Storage storage $, bytes32 orderHash) internal view returns (bool) {
        return $.preApproved[orderHash];
    }

    function getStorage() internal pure returns (Storage storage $) {
        assembly {
            $.slot := STORAGE_POSITION
        }
    }
}
