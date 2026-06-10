// SPDX-License-Identifier: BUSL-1.1
pragma solidity <0.9.0;

import { PolySafeLib } from "./PolySafeLib.sol";
import { PolyProxyLib } from "./PolyProxyLib.sol";

interface IPolyProxyFactory {
    function getImplementation() external returns (address);
}

interface IPolySafeFactory {
    function masterCopy() external returns (address);
}

library PolyFactoryHelper {
    // keccak256(abi.encode(uint256(keccak256("ctf.poly.factory.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 constant STORAGE_POSITION = 0x19e9fe6213b0291215a260ccf3658b8ca3add09948897a63b276aa255dbe1800;

    struct Storage {
        /// @notice The Polymarket Proxy Wallet Factory Contract
        address proxyFactory;
        /// @notice The Polymarket Proxy Wallet Implementation Contract
        address proxyImplementation;
        /// @notice The Polymarket Gnosis Safe Factory Contract
        address safeFactory;
        /// @notice The Polymarket Gnosis Safe Implementation Contract
        address safeImplementation;
        /// @notice Pre-computed keccak256 of the safe proxy creation code with the implementation
        bytes32 safeBytecodeHash;
    }

    function initialize(address proxyFactory, address safeFactory) internal {
        Storage storage $ = getStorage();

        $.proxyFactory = proxyFactory;
        $.safeFactory = safeFactory;

        $.proxyImplementation = IPolyProxyFactory(proxyFactory).getImplementation();

        address _safeImpl = IPolySafeFactory(safeFactory).masterCopy();
        $.safeImplementation = _safeImpl;
        $.safeBytecodeHash = PolySafeLib.computeBytecodeHash(_safeImpl);
    }

    /// @notice Gets the Proxy factory address
    function getProxyFactory() internal view returns (address) {
        Storage storage $ = getStorage();
        return $.proxyFactory;
    }

    /// @notice Gets the Safe factory address
    function getSafeFactory() internal view returns (address) {
        Storage storage $ = getStorage();
        return $.safeFactory;
    }

    /// @notice Gets the Proxy implementation address
    function getProxyImplementation() internal view returns (address) {
        Storage storage $ = getStorage();
        return $.proxyImplementation;
    }

    /// @notice Gets the Safe implementation address
    function getSafeImplementation() internal view returns (address) {
        Storage storage $ = getStorage();
        return $.safeImplementation;
    }

    /// @notice Gets the Polymarket proxy wallet address for an address
    /// @param _addr    - The address that owns the proxy wallet
    function getProxyWalletAddress(address _addr) internal view returns (address) {
        Storage storage $ = getStorage();
        return PolyProxyLib.getProxyWalletAddress(_addr, $.proxyImplementation, $.proxyFactory);
    }

    /// @notice Gets the Polymarket Gnosis Safe address for an address
    /// @param _addr    - The Safe owner/signer address used to derive the Safe address
    function getSafeWalletAddress(address _addr) internal view returns (address) {
        Storage storage $ = getStorage();
        return PolySafeLib.getSafeWalletAddress(_addr, $.safeBytecodeHash, $.safeFactory);
    }

    function getStorage() internal pure returns (Storage storage $) {
        assembly {
            $.slot := STORAGE_POSITION
        }
    }
}
