// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import './BridgeBase.sol';

contract BNCBridge is BridgeBase {
    constructor(address token) BridgeBase(token) {}
}