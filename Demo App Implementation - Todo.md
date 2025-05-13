# Demo App Implementation - Todo

## Phase 1: Smart Contract Refinements (BetEngine.sol)

- [ ] **Bet Struct Implementation**
    - [x] Collaboratively design `Bet` struct fields with the user.
    - [ ] Implement `BetStatus` enum in `BetEngine.sol`.
    - [ ] Implement `Bet` struct in `BetEngine.sol`.
    - [ ] Add state variables for managing bets (`mapping(uint256 => Bet) public bets;`, `uint256 public nextBetId;`) in `BetEngine.sol`.
    - [ ] User to review and add the above code to their `BetEngine.sol` on GitHub.
- [ ] **Refactor `placeBet` Function**
    - [ ] Modify `placeBet` to create and store a new `Bet` struct instance.
    - [ ] Ensure `placeBet` correctly handles `creatorStake` and `odds` within the new struct.
    - [ ] Update `BetPlaced` event to include relevant information from the `Bet` struct (e.g., `betId`).
    - [ ] User to review and update `placeBet` in their `BetEngine.sol` on GitHub.
- [ ] **Refactor `matchBet` Function**
    - [ ] Modify `matchBet` to update an existing `Bet` struct (identified by `betId`).
    - [ ] Ensure `matchBet` correctly sets the `matcher`, `matcherStake`, and updates `status` to `Matched`.
    - [ ] Update `BetMatched` event to include relevant information (e.g., `betId`).
    - [ ] User to review and update `matchBet` in their `BetEngine.sol` on GitHub.
- [ ] **Refactor `resolveBet` Function**
    - [ ] Modify `resolveBet` to update an existing `Bet` struct (identified by `betId`).
    - [ ] Implement accurate payout logic based on stakes and odds stored in the `Bet` struct.
    - [ ] Ensure `resolveBet` correctly sets the `winner` and updates `status` to `Resolved`.
    - [ ] Update `BetResolved` event to include relevant information (e.g., `betId`, `winner`, `payout`).
    - [ ] User to review and update `resolveBet` in their `BetEngine.sol` on GitHub.
- [ ] **Admin/Oracle Function for Resolution (Demo)**
    - [ ] Ensure `resolveBet` (or a new dedicated function) can be called by an admin/owner for demo purposes.
- [ ] **Review and Test Smart Contract Changes Locally**
    - [ ] User to write/update Hardhat tests for all new/modified functionalities in `BetEngine.sol`.
    - [ ] User to run tests locally and confirm they pass.

## Phase 2: Frontend Development (Core Demo UI)

- [ ] **Wallet Connection**
- [ ] **Display Bet Markets (Simple/Static for Demo)**
- [ ] **Place Bet UI & Interaction**
- [ ] **View & Match Bets UI & Interaction**
- [ ] **View Bet Status UI**
- [ ] **Basic Balance Display**

## Phase 3: Testnet Deployment & Demo Preparation

- [ ] **Deploy Contracts to Arbitrum Testnet**
- [ ] **Configure Frontend for Testnet**
- [ ] **Internal Testing on Testnet**
- [ ] **Prepare Demo Bets & Instructions for Friends**

## Phase 4: Gather Feedback

- [ ] **Conduct Demo with Friends**
- [ ] **Collect and Analyze Feedback**

