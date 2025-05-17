// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BetEngine {
    // --- Ownable Start ---
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }
    // --- Ownable End ---

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

    event BetPlaced(uint256 indexed betId, address indexed creator, uint256 indexed marketId, uint256 stake, uint256 odds);
    event BetMatched(uint256 indexed betId, address indexed creator, address indexed matcher, uint256 creatorStake, uint256 matcherStake, uint256 odds);
    event BetResolved(uint256 indexed betId, address indexed winner, address indexed loser, uint256 payoutAmount, uint256 marketId, uint256 odds);

    mapping(address => uint256) public balances; // Largely deprecated for bet stakes

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
        nextBetId = 1;      // Start bet IDs from 1
    }

    function placeBet(uint256 _marketId, uint256 _odds) external payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        require(_marketId != 0, "Market ID cannot be zero");
        require(_odds > 100, "Odds must be greater than 1.0 (e.g., 101 for 1.01)");

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

    function matchBet(uint256 _betId) external payable {
        Bet storage betToMatch = bets[_betId];
        require(betToMatch.id != 0, "Bet does not exist");
        require(betToMatch.status == BetStatus.Unmatched, "Bet is not available for matching");
        require(msg.sender != betToMatch.creator, "Cannot match your own bet");

        uint256 expectedMatcherStake = (betToMatch.creatorStake * (betToMatch.odds - 100)) / 100;
        require(msg.value == expectedMatcherStake, "Incorrect stake amount from matcher");

        betToMatch.matcher = msg.sender;
        betToMatch.matcherStake = msg.value;
        betToMatch.status = BetStatus.Matched;
        emit BetMatched(_betId, betToMatch.creator, msg.sender, betToMatch.creatorStake, betToMatch.matcherStake, betToMatch.odds);
    }

    // --- resolveBet function now with onlyOwner modifier ---
    function resolveBet(uint256 _betId, address _actualWinner) external onlyOwner {
        Bet storage betToResolve = bets[_betId];
        require(betToResolve.id != 0, "Bet does not exist");
        require(betToResolve.status == BetStatus.Matched, "Bet is not matched or already resolved/cancelled");
        require(_actualWinner == betToResolve.creator || _actualWinner == betToResolve.matcher, "Winner must be one of the participants");

        address loser;
        uint256 payoutAmount = betToResolve.creatorStake + betToResolve.matcherStake;

        if (_actualWinner == betToResolve.creator) {
            loser = betToResolve.matcher;
        } else {
            loser = betToResolve.creator;
        }

        betToResolve.winner = _actualWinner;
        betToResolve.status = BetStatus.Resolved;

        (bool success, ) = _actualWinner.call{value: payoutAmount}("");
        require(success, "Fund transfer failed");

        emit BetResolved(_betId, _actualWinner, loser, payoutAmount, betToResolve.marketId, betToResolve.odds);
    }
}
