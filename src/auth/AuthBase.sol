// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// interfaces
import { IAuth } from "./IAuth.sol";

// libraries
import { AuthStorage } from "./AuthStorage.sol";
import { CustomRevert } from "../utils/CustomRevert.sol";

// contracts
import { Facet } from "@towns-protocol/diamond/src/facets/Facet.sol";

abstract contract AuthBase is IAuth, Facet {
    using AuthStorage for AuthStorage.Storage;
    using CustomRevert for bytes4;

    modifier onlyAdmin() {
        if (!AuthStorage.getStorage().isAdmin(msg.sender)) NotAdmin.selector.revertWith();
        _;
    }

    modifier onlyOperator() {
        if (!AuthStorage.getStorage().isOperator(msg.sender)) NotOperator.selector.revertWith();
        _;
    }

    function __AuthFacet_init(address admin) internal initializer {
        AuthStorage.Storage storage $ = AuthStorage.getStorage();

        $.admins[admin] = true;
        $.operators[admin] = true;
        $.adminCount++;
    }

    function isAdmin(address caller) external view returns (bool) {
        return AuthStorage.getStorage().isAdmin(caller);
    }

    function isOperator(address caller) external view returns (bool) {
        return AuthStorage.getStorage().isOperator(caller);
    }

    function addAdmin(address admin) external {
        AuthStorage.Storage storage $ = AuthStorage.getStorage();

        if (!$.isAdmin(msg.sender)) NotAdmin.selector.revertWith();
        if ($.isAdmin(admin)) AlreadyAdmin.selector.revertWith();

        ++$.adminCount;
        $.admins[admin] = true;

        emit NewAdmin(admin, msg.sender);
    }

    function addOperator(address operator) external {
        AuthStorage.Storage storage $ = AuthStorage.getStorage();

        if (!$.isAdmin(msg.sender)) NotAdmin.selector.revertWith();
        if ($.isOperator(operator)) AlreadyOperator.selector.revertWith();

        $.operators[operator] = true;
        emit NewOperator(operator, msg.sender);
    }

    function removeAdmin(address admin) external {
        AuthStorage.Storage storage $ = AuthStorage.getStorage();

        if (!$.isAdmin(msg.sender) || !$.isAdmin(admin)) NotAdmin.selector.revertWith();

        --$.adminCount;
        $.admins[admin] = false;

        emit RemovedAdmin(admin, msg.sender);
    }

    function removeOperator(address operator) external {
        AuthStorage.Storage storage $ = AuthStorage.getStorage();

        if (!$.isAdmin(msg.sender)) NotAdmin.selector.revertWith();
        if (!$.isOperator(operator)) NotOperator.selector.revertWith();

        $.operators[operator] = false;
        emit RemovedOperator(operator, msg.sender);
    }

    function renounceOperatorRole() external {
        AuthStorage.Storage storage $ = AuthStorage.getStorage();
        if (!$.isOperator(msg.sender)) NotOperator.selector.revertWith();

        $.operators[msg.sender] = false;
        emit RemovedOperator(msg.sender, msg.sender);
    }
}
