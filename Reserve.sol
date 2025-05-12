
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Reserve {
    address public admin;
    uint public reserveBalance;

    event Funded(address indexed from, uint amount);
    event Withdrawn(address indexed to, uint amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function fundReserve() external payable {
        reserveBalance += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    function emergencyWithdraw(address payable to, uint amount) external onlyAdmin {
        require(amount <= reserveBalance, "Exceeds reserve");
        reserveBalance -= amount;
        to.transfer(amount);
        emit Withdrawn(to, amount);
    }
}
