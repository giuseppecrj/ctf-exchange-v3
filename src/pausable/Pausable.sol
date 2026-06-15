// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces
import { IUserPausable } from "./IUserPausable.sol";

// libraries
import { PausableStorage } from "./PaubleStorage.sol";
import { CustomRevert } from "../utils/CustomRevert.sol";

// contracts

abstract contract PausableBase is IUserPausable {
    using PausableStorage for PausableStorage.Storage;
    using CustomRevert for bytes4;

    /// @inheritdoc IUserPausable
    function isUserPaused(address user) external view returns (bool) {
        return PausableStorage.getStorage().isUserPaused(user);
    }

    /// @inheritdoc IUserPausable
    function pauseUser() external {
        PausableStorage.Storage storage $ = PausableStorage.getStorage();

        if ($.pausedAt[msg.sender] != 0) UserAlreadyPaused.selector.revertWith();

        uint256 blockPausedAt = block.number + $.blockInterval;
        $.pausedAt[msg.sender] = blockPausedAt;

        emit UserPaused(msg.sender, blockPausedAt);
    }

    /// @inheritdoc IUserPausable
    function unpauseUser() external {
        PausableStorage.getStorage().pausedAt[msg.sender] = 0;
        emit UserUnpaused(msg.sender);
    }
}
