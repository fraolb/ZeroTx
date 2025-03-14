// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SmartcontractAccount} from "src/SmartcontractAccount.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeploySmartcontractAccount is Script {
    function run() public {
        deploySmartcontractAccount();
    }

    function deploySmartcontractAccount()
        public
        returns (HelperConfig, SmartcontractAccount)
    {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vm.startBroadcast(config.account);
        SmartcontractAccount smartcontractAccount = new SmartcontractAccount(
            config.entryPoint
        );
        smartcontractAccount.transferOwnership(config.account);
        vm.stopBroadcast();
        return (helperConfig, smartcontractAccount);
    }
}
