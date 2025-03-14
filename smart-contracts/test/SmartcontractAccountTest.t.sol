// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {SmartcontractAccount} from "src/SmartcontractAccount.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {DeploySmartcontractAccount} from "script/DeploySmartcontractAccount.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract SmartcontractAccountTest is Test {
    HelperConfig helperConfig;
    SmartcontractAccount smartcontractAccount;

    uint256 constant AMOUNT = 1e18;
    ERC20Mock usdc;

    function setUp() public {
        DeploySmartcontractAccount deploySmartcontractAccount = new DeploySmartcontractAccount();
        (helperConfig, smartcontractAccount) = deploySmartcontractAccount
            .deploySmartcontractAccount();
        usdc = new ERC20Mock();
    }

    // test owner can execute
    function testOwnerCanExecuteCommands() public {
        // Arrange
        assertEq(usdc.balanceOf(address(smartcontractAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(
            ERC20Mock.mint.selector,
            address(smartcontractAccount),
            AMOUNT
        );
        // Act
        vm.prank(smartcontractAccount.owner());
        smartcontractAccount.execute(dest, value, functionData);

        // Assert
        assertEq(usdc.balanceOf(address(smartcontractAccount)), AMOUNT);
    }
}
