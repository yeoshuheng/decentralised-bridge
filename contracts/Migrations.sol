// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
    address public from = msg.sender;
    uint public last_completed;
    modifier restricted() {require(msg.sender == from, "You are not the contract owner."); _;}
    function update_complete_status(uint completed) public restricted {
        last_completed = completed;
    }
}