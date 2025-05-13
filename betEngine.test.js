const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BetEngine Contract", function () {
  it("should allow users to place a bet", async function () {
    const [owner] = await ethers.getSigners();
    const BetEngine = await ethers.getContractFactory("BetEngine");
    const bet = await BetEngine.deploy();
    await bet.placeBet(2, { value: ethers.utils.parseEther("1") });
    const balance = await bet.balances(owner.address);
    expect(balance).to.equal(ethers.utils.parseEther("1"));
  });
});
