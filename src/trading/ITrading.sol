// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces

// libraries
import { Side } from "../Structs.sol";

// contracts

interface ITrading {
    error OrderAlreadyFilled();
    error MakingGtRemaining();
    error NotCrossing();
    error TooLittleTokensReceived();
    error ComplementaryFillExceedsTakerFill();
    error MismatchedTokenIds();
    error MismatchedArrayLengths();
    error NoMakerOrders();
    error ZeroMakerAmount();
    error FeeExceedsProceeds();

    /// @notice Emitted when an order is filled
    event OrderFilled(
        bytes32 indexed orderHash,
        address indexed maker,
        address indexed taker,
        Side side,
        uint256 tokenId,
        uint256 makerAmountFilled,
        uint256 takerAmountFilled,
        uint256 fee,
        bytes32 builder,
        bytes32 metadata
    );

    /// @notice Emitted when a set of orders is matched
    event OrdersMatched(
        bytes32 indexed takerOrderHash,
        address indexed takerOrderMaker,
        Side side,
        uint256 tokenId,
        uint256 makerAmountFilled,
        uint256 takerAmountFilled
    );
}
