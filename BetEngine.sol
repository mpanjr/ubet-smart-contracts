// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BetEngine {
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
    uint256 public nextBetId;

    // --- Updated Event Definition for BetPlaced ---
    event BetPlaced(uint256 indexed betId, address indexed creator, uint256 indexed marketId, uint256 stake, uint256 odds);
    // --- Existing events - we will update these later ---
    event BetMatched(address indexed userA, address indexed userB, uint256 amount);
    event BetResolved(address indexed winner, uint256 payout);

    // Existing mapping - this will likely be deprecated for bet stakes
    mapping(address => uint256) public balances;

    constructor() {
        nextBetId = 1; // Start bet IDs from 1
    }

    // --- Refactored placeBet function ---
    function placeBet(uint256 _marketId, uint256 _odds) external payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        require(_marketId != 0, "Market ID cannot be zero"); // Basic validation for marketId

        uint256 currentBetId = nextBetId;

        bets[currentBetId] = Bet({
            id: currentBetId,
            creator: msg.sender,
            matcher: address(0),       // No matcher yet
            creatorStake: msg.value,   // Creator's stake is the sent value
            matcherStake: 0,           // No matcher stake yet
            odds: _odds,
            marketId: _marketId,
            status: BetStatus.Unmatched,
            winner: address(0)         // No winner yet
        });

        nextBetId++; // Increment for the next bet

        // Emit the updated event
        emit BetPlaced(currentBetId, msg.sender, _marketId, msg.value, _odds);

        // The old line `balances[msg.sender] += msg.value;` has been removed
        // as stakes are now managed within the Bet struct.
    }
    // --- End of Refactored placeBet function ---

    // Existing matchBet function - needs refactor next
    function matchBet(address opponent) external payable {
        // Current logic is placeholder and needs complete refactor
        require(balances[msg.sender] > 0 && balances[opponent] > 0, "Both must have placed bets");
        emit BetMatched(msg.sender, opponent, balances[msg.sender]);
    }

    // Existing resolveBet function - needs refactor later
    function resolveBet(address _winner, address _loser) external {
        // Current logic is placeholder and needs complete refactor
        uint256 payout = balances[_loser];
        balances[_winner] += payout;
        balances[_loser] = 0;
        emit BetResolved(_winner, payout);
    }
}
