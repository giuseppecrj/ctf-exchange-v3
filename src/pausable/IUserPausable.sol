// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces

// libraries

// contracts

interface IUserPausable {
    error UserIsPaused();
    error UserAlreadyPaused();
    error ExceedsMaxPauseInterval();

    /// @notice Emitted when the user pause block interval is updated
    event UserPauseBlockIntervalUpdated(uint256 oldInterval, uint256 newInterval);

    /// @notice Emitted when a user pauses their account
    event UserPaused(address indexed user, uint256 effectivePauseBlock);

    /// @notice Emitted when a user unpauses their account
    event UserUnpaused(address indexed user);

    /// @notice Checks if a user is currently paused
    /// @param user - The user address to check
    function isUserPaused(address user) external view returns (bool);

    /// @notice Allows a user to pause their account
    function pauseUser() external;

    /// @notice Allows a user to unpause their account
    function unpauseUser() external;
}
