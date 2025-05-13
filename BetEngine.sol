// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BetEngine {
    // --- New Additions Start ---
    enum BetStatus { Unmatched, Matched, Resolved, Cancelled }

    struct Bet {
        uint256 id;            // Unique identifier for the bet
        address creator;       // The address of the user who created the bet
        address matcher;       // The address of the user who matched the bet, address(0) if unmatched
        uint256 creatorStake;  // The amount staked by the creator
        uint256 matcherStake;  // The amount staked by the matcher
        uint256 odds;          // Odds set by the creator (e.g., payout multiplier for creator if they win)
        uint256 marketId;      // An identifier for the specific event or market
        BetStatus status;      // Current status of the bet
        address winner;        // Address of the winner, address(0) until resolved
    }

    mapping(uint256 => Bet) public bets;
    uint256 public nextBetId; // Will be initialized to 0 by default, or set in constructor
    // --- New Additions End ---

    // Existing events - we will update these later when refactoring functions
    event BetPlaced(address indexed user, uint256 amount, uint256 odds);
    event BetMatched(address indexed userA, address indexed userB, uint256 amount);
    event BetResolved(address indexed winner, uint256 payout);

    // Existing mapping - this will likely be replaced or refactored when functions are updated
    mapping(address => uint256) public balances;

    // --- Constructor to initialize nextBetId (Optional but good practice) ---
    constructor() {
        nextBetId = 1; // Start bet IDs from 1
    }
    // --- Constructor End ---

    // Existing functions - these will need to be refactored in subsequent steps
    function placeBet(uint256 _odds) external payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit BetPlaced(msg.sender, msg.value, _odds);
    }

    function matchBet(address opponent) external payable { // Made payable to accept matcher's stake
        // Current logic is placeholder and needs complete refactor
        require(balances[msg.sender] > 0 && balances[opponent] > 0, "Both must have placed bets");
        emit BetMatched(msg.sender, opponent, balances[msg.sender]);
    }

    function resolveBet(address _winner, address _loser) external {
        // Current logic is placeholder and needs complete refactor
        uint256 payout = balances[_loser];
        balances[_winner] += payout;
        balances[_loser] = 0;
        emit BetResolved(_winner, payout);
    }
}

