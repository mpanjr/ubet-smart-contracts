// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BetEngine {
    event BetPlaced(address indexed user, uint256 amount, uint256 odds);
    event BetMatched(address indexed userA, address indexed userB, uint256 amount);
    event BetResolved(address indexed winner, uint256 payout);

    mapping(address => uint256) public balances;

    function placeBet(uint256 odds) external payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit BetPlaced(msg.sender, msg.value, odds);
    }

    function matchBet(address opponent) external {
        require(balances[msg.sender] > 0 && balances[opponent] > 0, "Both must have placed bets");
        emit BetMatched(msg.sender, opponent, balances[msg.sender]);
    }

    function resolveBet(address winner, address loser) external {
        uint256 payout = balances[loser];
        balances[winner] += payout;
        balances[loser] = 0;
        emit BetResolved(winner, payout);
    }
}
