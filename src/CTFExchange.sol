// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// interfaces
import { ICTFExchange } from "./ICTFExchange.sol";

// libraries

// contracts
import { Receiver } from "solady/src/accounts/Receiver.sol";

contract CTFExchange is ICTFExchange, Receiver { }
