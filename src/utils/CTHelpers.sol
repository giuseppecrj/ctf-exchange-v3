// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.5.1;

// forked from Gnosis Condtional Tokens
library CTHelpers {
    /// @dev Constructs a condition ID from an oracle, a question ID, and the outcome slot count for
    /// the question.
    /// @param oracle The account assigned to report the result for the prepared condition.
    /// @param questionId An identifier for the question to be answered by the oracle.
    /// @param outcomeSlotCount The number of outcome slots which should be used for this condition.
    /// Must not exceed 256.
    function getConditionId(
        address oracle,
        bytes32 questionId,
        uint256 outcomeSlotCount
    )
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount));
    }

    uint256 constant P =
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_226_208_583;
    uint256 constant B = 3;
    uint256 private constant EXP_SQRT_FP = 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52;

    /// @dev Modular square root in Fp via modexp: y = x^((P+1)/4) mod P.
    function sqrt(uint256 x) private view returns (uint256 y) {
        assembly ("memory-safe") {
            let m := mload(0x40)
            mstore(m, 0x20)
            mstore(add(m, 0x20), 0x20)
            mstore(add(m, 0x40), 0x20)
            mstore(add(m, 0x60), x)
            mstore(add(m, 0x80), EXP_SQRT_FP)
            mstore(add(m, 0xa0), P)
            if iszero(staticcall(gas(), 0x05, m, 0xc0, m, 0x20)) { revert(0, 0) }
            y := mload(m)
        }
    }

    /// @dev Constructs an outcome collection ID from a parent collection and an outcome collection.
    /// @param parentCollectionId Collection ID of the parent outcome collection, or bytes32(0) if
    /// there's no parent.
    /// @param conditionId Condition ID of the outcome collection to combine with the parent outcome
    /// collection.
    /// @param indexSet Index set of the outcome collection to combine with the parent outcome
    /// collection.
    function getCollectionId(
        bytes32 parentCollectionId,
        bytes32 conditionId,
        uint256 indexSet
    )
        internal
        view
        returns (bytes32)
    {
        uint256 x1 = uint256(keccak256(abi.encodePacked(conditionId, indexSet)));
        bool odd = x1 >> 255 != 0;
        uint256 y1;
        uint256 yy;
        do {
            x1 = addmod(x1, 1, P);
            yy = addmod(mulmod(x1, mulmod(x1, x1, P), P), B, P);
            y1 = sqrt(yy);
        } while (mulmod(y1, y1, P) != yy);
        if ((odd && y1 % 2 == 0) || (!odd && y1 % 2 == 1)) y1 = P - y1;

        uint256 x2 = uint256(parentCollectionId);
        if (x2 != 0) {
            odd = x2 >> 254 != 0;
            x2 = (x2 << 2) >> 2;
            yy = addmod(mulmod(x2, mulmod(x2, x2, P), P), B, P);
            uint256 y2 = sqrt(yy);
            if ((odd && y2 % 2 == 0) || (!odd && y2 % 2 == 1)) y2 = P - y2;
            require(mulmod(y2, y2, P) == yy, "invalid parent collection ID");

            (bool success, bytes memory ret) = address(6).staticcall(abi.encode(x1, y1, x2, y2));
            require(success, "ecadd failed");
            (x1, y1) = abi.decode(ret, (uint256, uint256));
        }

        if (y1 % 2 == 1) x1 ^= 1 << 254;

        return bytes32(x1);
    }

    /// @dev Constructs a position ID from a collateral token and an outcome collection. These IDs
    /// are used as the ERC-1155 ID for this contract.
    /// @param collateralToken Collateral token which backs the position.
    /// @param collectionId ID of the outcome collection associated with this position.
    function getPositionId(address collateralToken, bytes32 collectionId) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(collateralToken, collectionId)));
    }
}
