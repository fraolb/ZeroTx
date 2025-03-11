// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SimpleERC4337Wallet {
    using ECDSA for bytes32;

    address public owner;
    uint256 public nonce;

    event TransactionExecuted(address indexed dest, uint256 value, bytes data);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the wallet owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function execute(
        address dest,
        uint256 value,
        bytes calldata data
    ) external onlyOwner {
        (bool success, ) = dest.call{value: value}(data);
        require(success, "Transaction failed");
        emit TransactionExecuted(dest, value, data);
    }

    function validateUserOp(
        address sender,
        uint256 _nonce,
        bytes calldata data,
        bytes calldata signature
    ) external returns (bool) {
        require(sender == address(this), "Invalid sender");
        require(_nonce == nonce, "Invalid nonce");

        bytes32 hash = keccak256(abi.encodePacked(sender, _nonce, data));
        address ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(
            hash
        );
        address signer = ECDSA.recover(ethSignedMessageHash, signature);
        require(signer == owner, "Invalid signature");

        nonce++; // Increment nonce after successful validation
        return true;
    }

    receive() external payable {}
}
