// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Reserve {
    uint256 public reservePool;

    function fundReserve() external payable {
        reservePool += msg.value;
    }

    function useReserve(uint256 amount) external {
        require(amount <= reservePool, "Insufficient reserve");
        reservePool -= amount;
    }

    function getReserve() external view returns (uint256) {
        return reservePool;
    }
}
