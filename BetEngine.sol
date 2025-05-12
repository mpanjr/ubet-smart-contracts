
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BetEngine {
    enum BetStatus { Open, Matched, Resolved }
    struct Bet {
        address creator;
        uint amount;
        uint odds;
        BetStatus status;
        address matcher;
        bool outcome; // true or false prediction
    }

    mapping(uint => Bet) public bets;
    uint public betCounter;

    event BetCreated(uint indexed betId, address indexed creator, uint amount, uint odds);
    event BetMatched(uint indexed betId, address indexed matcher);
    event BetResolved(uint indexed betId, bool outcome, address winner);

    function createBet(uint odds, bool outcome) external payable {
        require(msg.value > 0, "Stake required");
        bets[betCounter] = Bet(msg.sender, msg.value, odds, BetStatus.Open, address(0), outcome);
        emit BetCreated(betCounter, msg.sender, msg.value, odds);
        betCounter++;
    }

    function matchBet(uint betId) external payable {
        Bet storage bet = bets[betId];
        require(bet.status == BetStatus.Open, "Already matched");
        require(msg.value == bet.amount, "Stake must match");
        bet.matcher = msg.sender;
        bet.status = BetStatus.Matched;
        emit BetMatched(betId, msg.sender);
    }

    function resolveBet(uint betId, bool outcome) external {
        Bet storage bet = bets[betId];
        require(bet.status == BetStatus.Matched, "Not matched yet");
        bet.status = BetStatus.Resolved;
        address winner = (bet.outcome == outcome) ? bet.creator : bet.matcher;
        payable(winner).transfer(bet.amount * 2);
        emit BetResolved(betId, outcome, winner);
    }
}
