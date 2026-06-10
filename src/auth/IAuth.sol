// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title IAuth
/// @notice External interface for admin and operator role management on the exchange.
interface IAuth {
    error NotAdmin();
    error NotOperator();
    error LastAdmin();
    error AlreadyAdmin();
    error AlreadyOperator();

    /// @notice Emitted when a new admin is added
    event NewAdmin(address indexed newAdminAddress, address indexed admin);

    /// @notice Emitted when a new operator is added
    event NewOperator(address indexed newOperatorAddress, address indexed admin);

    /// @notice Emitted when an admin is removed
    event RemovedAdmin(address indexed removedAdmin, address indexed admin);

    /// @notice Emitted when an operator is removed
    event RemovedOperator(address indexed removedOperator, address indexed admin);

    /// @notice Returns whether `account` holds the admin role.
    /// @param account The address to query.
    /// @return True if `account` is an admin.
    function isAdmin(address account) external view returns (bool);

    /// @notice Returns whether `account` holds the operator role.
    /// @param account The address to query.
    /// @return True if `account` is an operator.
    function isOperator(address account) external view returns (bool);

    /// @notice Grants the admin role to `admin`.
    /// @dev Callable only by an existing admin. Reverts if `admin` is already an admin.
    /// @param admin The address to grant admin privileges.
    function addAdmin(address admin) external;

    /// @notice Grants the operator role to `operator`.
    /// @dev Callable only by an admin. Reverts if `operator` is already an operator.
    /// @param operator The address to grant operator privileges.
    function addOperator(address operator) external;

    /// @notice Revokes the admin role from `admin`.
    /// @dev Callable only by an admin. Reverts if `admin` is not an admin.
    /// @param admin The address to remove from admins.
    function removeAdmin(address admin) external;

    /// @notice Revokes the operator role from `operator`.
    /// @dev Callable only by an admin. Reverts if `operator` is not an operator.
    /// @param operator The address to remove from operators.
    function removeOperator(address operator) external;

    /// @notice Revokes the operator role from the caller.
    /// @dev Callable only by the caller when they hold the operator role.
    function renounceOperatorRole() external;
}
