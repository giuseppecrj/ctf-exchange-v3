// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces
import { IUserPausable } from "./IUserPausable.sol";

// libraries

// contracts

library PausableStorage {
    // keccak256(abi.encode(uint256(keccak256("ctf.user.pausable.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 constant STORAGE_POSITION = 0xc1f8fa0d242e3693ccd274a6b4c67291c4c0e6a7f684a62c4bd74e72b44ac600;

    /// @notice Maximum allowed value for the user pause block interval
    uint256 internal constant MAX_PAUSE_BLOCK_INTERVAL = 302_400;

    struct Storage {
        uint256 blockInterval;
        mapping(address => uint256) pausedAt;
    }

    function isUserPaused(Storage storage $, address user) internal view returns (bool) {
        uint256 pausedAt = $.pausedAt[user];
        return pausedAt > 0 && block.number >= pausedAt;
    }

    function setBlockInterval(Storage storage $, uint256 blockInterval) internal {
        require(blockInterval <= MAX_PAUSE_BLOCK_INTERVAL, IUserPausable.ExceedsMaxPauseInterval());

        uint256 userPauseBlockInterval = $.blockInterval;

        uint256 oldInterval = userPauseBlockInterval;
        userPauseBlockInterval = blockInterval;

        emit IUserPausable.UserPauseBlockIntervalUpdated(oldInterval, blockInterval);
    }

    function getStorage() internal pure returns (Storage storage $) {
        assembly {
            $.slot := STORAGE_POSITION
        }
    }
}
