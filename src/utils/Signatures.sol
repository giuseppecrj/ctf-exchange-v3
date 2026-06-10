// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces

// libraries
import { Order, SignatureType } from "../Structs.sol";
import { CustomRevert } from "./CustomRevert.sol";
import { ECDSA } from "solady/src/utils/ECDSA.sol";
import { SignatureCheckerLib } from "solady/src/utils/SignatureCheckerLib.sol";
import { PolyProxyLib } from "./PolyProxyLib.sol";
import { PolySafeLib } from "./PolySafeLib.sol";
import { PolyFactoryHelper } from "./PolyFactory.sol";

// contracts
import { TradingStorage } from "../trading/TradingStorage.sol";

library Signatures {
    using CustomRevert for bytes4;
    using TradingStorage for TradingStorage.Storage;

    /// @notice Immutable wallet factory config for proxy/Safe address derivation.
    struct WalletConfig {
        /// @notice Polymarket proxy factory address.
        address proxyFactory;
        /// @notice Polymarket proxy implementation address.
        address proxyImplementation;
        /// @notice Polymarket Gnosis Safe factory address.
        address safeFactory;
        /// @notice Pre-computed Safe proxy creation code hash.
        bytes32 safeBytecodeHash;
    }

    error InvalidSignature();

    /// @notice Emitted when an order is preapproved
    event OrderPreapproved(bytes32 indexed orderHash);

    /// @notice Emitted when a preapproval is invalidated
    event OrderPreapprovalInvalidated(bytes32 indexed orderHash);

    function validate(bytes32 orderHash, Order calldata order) internal view {
        TradingStorage.Storage storage $ = TradingStorage.getStorage();

        if (order.signature.length == 0) {
            if (!$.isPreapproved(orderHash)) InvalidSignature.selector.revertWith();
        } else {
            if (!isValid(order.signer, order.maker, orderHash, order.signature, order.signatureType)) {
                InvalidSignature.selector.revertWith();
            }
        }
    }

    /// @notice Returns whether an order signature is valid for the given hash.
    /// @param signer Order signer address.
    /// @param maker Order maker (funds source) address.
    /// @param orderHash EIP-712 digest of the order.
    /// @param signature Order signature bytes.
    /// @param signatureType Declared signature type on the order.
    function isValid(
        address signer,
        address maker,
        bytes32 orderHash,
        bytes calldata signature,
        SignatureType signatureType
    )
        internal
        view
        returns (bool)
    {
        if (signatureType == SignatureType.EOA) {
            return verifyEOA(signer, maker, orderHash, signature);
        }
        if (signatureType == SignatureType.POLY_GNOSIS_SAFE) {
            return verifyPolySafe(signer, maker, orderHash, signature);
        }
        if (signatureType == SignatureType.POLY_1271) {
            return verifyPoly1271(signer, maker, orderHash, signature);
        }
        return verifyPolyProxy(signer, maker, orderHash, signature);
    }

    /// @notice Verifies EOA ECDSA and signer == maker.
    function verifyEOA(
        address signer,
        address maker,
        bytes32 orderHash,
        bytes calldata signature
    )
        internal
        view
        returns (bool)
    {
        return signer == maker && verifyECDSA(signer, orderHash, signature);
    }

    /// @notice Verifies ECDSA recovery against the expected signer.
    function verifyECDSA(address signer, bytes32 orderHash, bytes calldata signature) internal view returns (bool) {
        return ECDSA.recoverCalldata(orderHash, signature) == signer;
    }

    /// @notice Verifies EOA signature and derived proxy wallet ownership.
    function verifyPolyProxy(
        address signer,
        address maker,
        bytes32 orderHash,
        bytes calldata signature
    )
        private
        view
        returns (bool)
    {
        WalletConfig memory config = _walletConfig();
        return verifyECDSA(signer, orderHash, signature)
            && PolyProxyLib.getProxyWalletAddress(signer, config.proxyImplementation, config.proxyFactory) == maker;
    }

    /// @notice Verifies EOA signature and derived Gnosis Safe ownership.
    function verifyPolySafe(
        address signer,
        address maker,
        bytes32 orderHash,
        bytes calldata signature
    )
        private
        view
        returns (bool)
    {
        WalletConfig memory config = _walletConfig();
        return verifyECDSA(signer, orderHash, signature)
            && PolySafeLib.getSafeWalletAddress(signer, config.safeBytecodeHash, config.safeFactory) == maker;
    }

    /// @notice Verifies ERC-1271 signature from a smart contract wallet.
    function verifyPoly1271(
        address signer,
        address maker,
        bytes32 orderHash,
        bytes calldata signature
    )
        private
        view
        returns (bool)
    {
        return signer == maker && maker.code.length > 0
            && SignatureCheckerLib.isValidSignatureNowCalldata(maker, orderHash, signature);
    }

    function _walletConfig() internal view returns (WalletConfig memory config) {
        PolyFactoryHelper.Storage storage $ = PolyFactoryHelper.getStorage();

        config = WalletConfig({
            proxyFactory: $.proxyFactory,
            proxyImplementation: $.proxyImplementation,
            safeFactory: $.safeFactory,
            safeBytecodeHash: $.safeBytecodeHash
        });
    }
}
