// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// interfaces
import { ITrading } from "./ITrading.sol";

// libraries
import { CustomRevert } from "../utils/CustomRevert.sol";
import { Side, Order, ORDER_TYPEHASH } from "../Structs.sol";
import { TradingStorage } from "./TradingStorage.sol";
import { Signatures } from "../utils/Signatures.sol";
import { CTHelpers } from "../utils/CTHelpers.sol";

// contracts
import { EIP712 } from "solady/src/utils/EIP712.sol";

abstract contract TradingBase is EIP712, ITrading {
    using CustomRevert for bytes4;
    using TradingStorage for TradingStorage.Storage;
    using Signatures for bytes32;

    struct PreparedMakerOrder {
        bytes32 orderHash;
        uint256 makingAmount;
        uint256 takingAmount;
        address maker;
        uint256 takerAssetId;
        Side side;
        uint256 feeAmount;
        bytes32 builder;
        bytes32 metadata;
        uint256 tokenId;
    }

    function validateOrder(Order calldata order) external view {
        bytes32 orderHash = _hashOrder(order);

        TradingStorage.Storage storage $ = TradingStorage.getStorage();

        if ($.orderStatus[orderHash].filled) OrderAlreadyFilled.selector.revertWith();

        _validateOrder(orderHash, order);
    }

    function matchOrders(
        bytes32 conditionId,
        Order calldata takerOrder,
        Order[] calldata makerOrders,
        uint256 takerFillAmount,
        uint256[] calldata makerFillAmount,
        uint256 takerFeeAmount,
        uint256[] calldata makerFeeAmounts
    )
        internal { }

    // Internal

    function _validateTokenIds(bytes32 conditionId, Order memory takerOrder, Order[] memory makerOrders) internal view {
        address col = getCtfCollateral();
        uint256 pos1 = CTHelpers.getPositionId(col, CTHelpers.getCollectionId(bytes32(0), conditionId, 1));
        uint256 pos2 = CTHelpers.getPositionId(col, CTHelpers.getCollectionId(bytes32(0), conditionId, 2));

        uint256 takerTokenId = takerOrder.tokenId;
        require(takerTokenId == pos1 || takerTokenId == pos2, MismatchedTokenIds());

        for (uint256 i = 0; i < makerOrders.length; ++i) {
            uint256 makerTokenId = makerOrders[i].tokenId;
            require(makerTokenId == pos1 || makerTokenId == pos2, MismatchedTokenIds());
        }
    }

    function _hashOrder(Order calldata order) internal view returns (bytes32 orderHash) {
        return _hashTypedData(
            keccak256(
                abi.encode(
                    ORDER_TYPEHASH,
                    order.salt,
                    order.maker,
                    order.signer,
                    order.tokenId,
                    order.makerAmount,
                    order.takerAmount,
                    order.side,
                    order.signatureType,
                    order.timestamp,
                    order.metadata,
                    order.builder
                )
            )
        );
    }

    function _validateOrder(bytes32 orderHash, Order calldata order) internal view {
        // Validate order is not zero-sized
        // require(order.makerAmount > 0, ZeroMakerAmount());
        if (order.makerAmount < 0) ZeroMakerAmount.selector.revertWith();

        Signatures.validate(orderHash, order);
    }
}
