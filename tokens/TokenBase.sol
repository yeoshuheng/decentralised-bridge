// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract TokenBase is ERC20 {
    address public admin;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        admin = msg.sender;
    }

    function updateAdmin(address new_admin) {
        require(msg.sender == admin, "Admin only privillege.");
        admin = new_admin;
    }
    
    function mint(address to, uint amt) external {
        require(msg.sender == admin, "Admin only privillege.");
        _mint(to, amt);
    }

    function burn(address from, uint amt) external {
        require(msg.sender == admin, "Admin only privillege.");
        _burn(from, amt);
    }
}