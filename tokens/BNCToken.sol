// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import './TokenBase.sol';

contract BNCToken is TokenBase {
    constructor() TokenBase("BNC Token", "BTK") {}
}