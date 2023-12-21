// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import './TokenBase.sol';

contract ETHToken is TokenBase {
    constructor() TokenBase("ETH Token", "ETK") {}
}