const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BetEngine", function () {
    let BetEngine;
    let betEngine;
    let owner;
    let addr1; // Represents a bet creator
    let addr2; // Represents a bet matcher
    let addrs;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        BetEngine = await ethers.getContractFactory("BetEngine");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        // Deploy a new BetEngine contract before each test.
        betEngine = await BetEngine.deploy();
        await betEngine.deployed();
    });

    // --- Tests for placeBet ---
    describe("placeBet", function () {
        it("Should allow a user to place a bet successfully", async function () {
            const marketId = 1;
            const odds = 200; // Represents 2.0 odds
            const stake = ethers.utils.parseEther("1.0");

            await expect(betEngine.connect(addr1).placeBet(marketId, odds, { value: stake }))
                .to.emit(betEngine, "BetPlaced")
                .withArgs(1, addr1.address, marketId, stake, odds); // betId will be 1

            const bet = await betEngine.bets(1);
            expect(bet.id).to.equal(1);
            expect(bet.creator).to.equal(addr1.address);
            expect(bet.creatorStake).to.equal(stake);
            // ... more assertions
        });

        it("Should fail if stake is zero", async function () {
            // ... test logic
        });
        // ... more placeBet tests
    });

    // --- Tests for matchBet ---
    describe("matchBet", function () {
        // You might need a beforeEac`h here to place a bet first
        it("Should allow a user to match a bet successfully", async function () {
            // ... test logic
        });
        // ... more matchBet tests
    });

    // --- Tests for resolveBet ---
    describe("resolveBet", function () {
        // You might need a beforeEach here to place and match a bet first
        it("Should allow the owner to resolve a bet successfully", async function () {
            // ... test logic
        });
        // ... more resolveBet tests
    });
});

