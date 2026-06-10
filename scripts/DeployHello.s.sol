// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

//interfaces

//libraries

//contracts
import { Deployer } from "./utils/Deployer.s.sol";
import { CTFExchange } from "src/CTFExchange.sol";

contract DeployHello is Deployer {
    function versionName() public pure override returns (string memory) {
        return "hello";
    }

    function __deploy(address deployer) public override returns (address) {
        vm.broadcast(deployer);
        // return address(new CTFExchange());
    }
}
