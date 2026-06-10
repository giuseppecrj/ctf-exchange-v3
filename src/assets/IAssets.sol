// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces

// libraries

// contracts

interface IAssets {
    function getCollateral() external returns (address);

    function getCtf() external returns (address);

    function getCtfCollateral() external returns (address);

    function getOutcomeTokenFactory() external returns (address);
}
