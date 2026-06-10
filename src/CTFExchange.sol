// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// interfaces
import { ExchangeInitParams } from "./Structs.sol";

// libraries
import { AuthBase } from "./auth/AuthBase.sol";

// contracts
import { Receiver } from "solady/src/accounts/Receiver.sol";

contract CTFExchange is AuthBase, Receiver {
    constructor(ExchangeInitParams memory params) {
        __AuthFacet_init(params.admin);
    }
}
