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
        uint256 odds;          // Odds set by the creator (e.g., payout multiplier for creator if they win, x100)
        uint256 marketId;      // An identifier for the specific event or market
        BetStatus status;      // Current status of the bet
        address winner;        // Address of the winner, address(0) until resolved
    }

    mapping(uint256 => Bet) public bets;
    uint256 public nextBetId;

    // --- Event Definitions ---
    event BetPlaced(uint256 indexed betId, address indexed creator, uint256 indexed marketId, uint256 stake, uint256 odds);
    event BetMatched(uint256 indexed betId, address indexed creator, address indexed matcher, uint256 creatorStake, uint256 matcherStake, uint256 odds);
    event BetResolved(address indexed winner, uint256 payout); // We will update this later

    // Existing mapping - this will likely be deprecated for bet stakes as stakes are in Bet struct
    mapping(address => uint256) public balances;

    constructor() {
        nextBetId = 1; // Start bet IDs from 1
    }

    function placeBet(uint256 _marketId, uint256 _odds) external payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        require(_marketId != 0, "Market ID cannot be zero");
        require(_odds > 100, "Odds must be greater than 1.0 (e.g., 101 for 1.01)"); // Ensure odds allow for profit

        uint256 currentBetId = nextBetId;

        bets[currentBetId] = Bet({
            id: currentBetId,
            creator: msg.sender,
            matcher: address(0),
            creatorStake: msg.value,
            matcherStake: 0,
            odds: _odds,
            marketId: _marketId,
            status: BetStatus.Unmatched,
            winner: address(0)
        });

        nextBetId++;
        emit BetPlaced(currentBetId, msg.sender, _marketId, msg.value, _odds);
    }

    // --- Refactored matchBet function ---
    function matchBet(uint256 _betId) external payable {
        Bet storage betToMatch = bets[_betId]; // Use storage pointer for efficiency

        require(betToMatch.id != 0, "Bet does not exist");
        require(betToMatch.status == BetStatus.Unmatched, "Bet is not available for matching");
        require(msg.sender != betToMatch.creator, "Cannot match your own bet");
        // betToMatch.odds should already be > 100 from placeBet

        // Calculate the stake required from the matcher (creator's potential profit)
        uint256 expectedMatcherStake = (betToMatch.creatorStake * (betToMatch.odds - 100)) / 100;
        require(msg.value == expectedMatcherStake, "Incorrect stake amount from matcher");

        betToMatch.matcher = msg.sender;
        betToMatch.matcherStake = msg.value; // This is the expectedMatcherStake
        betToMatch.status = BetStatus.Matched;

        emit BetMatched(_betId, betToMatch.creator, msg.sender, betToMatch.creatorStake, betToMatch.matcherStake, betToMatch.odds);
    }
    // --- End of Refactored matchBet function ---

    // Existing resolveBet function - needs refactor later
    function resolveBet(address _winner, address _loser) external {
        // Current logic is placeholder and needs complete refactor
        uint256 payout = balances[_loser]; // This logic is now incorrect
        balances[_winner] += payout;
        balances[_loser] = 0;
        emit BetResolved(_winner, payout);
    }
}
