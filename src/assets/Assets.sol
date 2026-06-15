// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces
import { ERC20 } from "solady/src/tokens/ERC20.sol";
import { ERC1155 } from "solady/src/tokens/ERC1155.sol";

// libraries
import { AssetsStorage } from "./AssetsStorage.sol";

// contracts
import { Facet } from "@towns-protocol/diamond/src/facets/Facet.sol";

abstract contract AssetsBase is Facet {
    using AssetsStorage for AssetsStorage.Storage;

    struct Storage {
        address collateral;
        address ctf;
        address ctfCollateral;
        address outcomeTokenFactory;
    }

    function __Assets__init(
        address collateral,
        address ctf,
        address ctfCollateral,
        address outcomeTokenFactory
    )
        internal
        initializer
    {
        AssetsStorage.Storage storage $ = AssetsStorage.getStorage();
        ($.collateral, $.ctf, $.ctfCollateral, $.outcomeTokenFactory) =
        (collateral, ctf, ctfCollateral, outcomeTokenFactory);

        ERC20(collateral).approve(outcomeTokenFactory, type(uint256).max);
        ERC1155(ctf).setApprovalForAll(outcomeTokenFactory, true);
    }

    /// @notice Returns the collateral token address
    function getCollateral() external view returns (address) {
        return AssetsStorage.getStorage().collateral;
    }

    /// @notice Returns the Conditional Tokens Framework address
    function getCtf() external view returns (address) {
        return AssetsStorage.getStorage().ctf;
    }

    /// @notice Returns the collateral address used by the CTF for position ID derivation
    function getCtfCollateral() external view returns (address) {
        return AssetsStorage.getStorage().getCtfCollateral();
    }

    /// @notice Returns the address that facilitates outcome token minting or merging
    function getOutcomeTokenFactory() external view returns (address) {
        return AssetsStorage.getStorage().outcomeTokenFactory;
    }
}
