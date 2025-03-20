// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IEntryPoint} from "@account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract Paymaster {
    IEntryPoint public immutable entryPoint;
    mapping(address => bool) public whitelist;

    constructor(address _entryPoint) {
        entryPoint = IEntryPoint(_entryPoint);
    }

    function deposit() external payable {
        entryPoint.depositTo{value: msg.value}(address(this));
    }

    function addToWhitelist(address user) external {
        whitelist[user] = true;
    }

    function validatePaymasterUserOp(
        bytes calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) external view returns (bytes memory context, uint256 validationData) {
        address user = address(bytes20(userOp[24:44])); // Extract user address from UserOperation
        require(whitelist[user], "User not whitelisted");
        return ("", 0);
    }

    function postOp(
        bytes calldata context,
        bool success,
        uint256 actualGasCost
    ) external {
        // Handle post-operation logic (e.g., refund excess gas).
    }
}
