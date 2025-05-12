
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BetEngine", function () {
  let betEngine, owner, user1, user2;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    const BetEngine = await ethers.getContractFactory("BetEngine");
    betEngine = await BetEngine.deploy();
    await betEngine.deployed();
  });

  it("should allow user to create a bet", async function () {
    await expect(betEngine.connect(user1).createBet(2, true, { value: ethers.utils.parseEther("1") }))
      .to.emit(betEngine, "BetCreated");
  });

  it("should allow another user to match a bet", async function () {
    await betEngine.connect(user1).createBet(2, true, { value: ethers.utils.parseEther("1") });
    await expect(betEngine.connect(user2).matchBet(0, { value: ethers.utils.parseEther("1") }))
      .to.emit(betEngine, "BetMatched");
  });

  it("should resolve the bet correctly", async function () {
    await betEngine.connect(user1).createBet(2, true, { value: ethers.utils.parseEther("1") });
    await betEngine.connect(user2).matchBet(0, { value: ethers.utils.parseEther("1") });
    await expect(betEngine.resolveBet(0, true))
      .to.emit(betEngine, "BetResolved");
  });
});
