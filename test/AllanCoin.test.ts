import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("AllanCoin Tests", function () {

  async function deployFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const AllanCoin = await ethers.getContractFactory("AllanCoin");
    const allanCoin = await AllanCoin.deploy();

    return { allanCoin, owner, otherAccount };
  }

  it("Should have correct name", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const name = await allanCoin.name();
    expect(name).to.equal("AllanCoin");
  });

  it("Should have correct symbol", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const symbol = await allanCoin.symbol();
    expect(symbol).to.equal("ALC");
  });

  it("Should have correct decimals", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const decimals = await allanCoin.decimals();
    expect(decimals).to.equal(18);
  });

  it("Should have correct totalSupply", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const totalSupply = await allanCoin.totalSupply();
    expect(totalSupply).to.equal(1000n * 10n ** 18n);
  });

  it("Should get balance", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const balance = await allanCoin.balanceOf(owner.address);
    expect(balance).to.equal(1000n * 10n ** 18n);
  });

  it("Should transfer", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const balanceOwnerBefore = await allanCoin.balanceOf(owner.address);
    const balanceOtherBefore = await allanCoin.balanceOf(otherAccount.address);

    await allanCoin.transfer(otherAccount.address, 1n);

    const balanceOwnerAfter = await allanCoin.balanceOf(owner.address);
    const balanceOtherAfter = await allanCoin.balanceOf(otherAccount.address);

    expect(balanceOwnerBefore).to.equal(1000n * 10n ** 18n);
    expect(balanceOwnerAfter).to.equal((1000n * 10n ** 18n) - 1n);
    expect(balanceOtherBefore).to.equal(0);
    expect(balanceOtherAfter).to.equal(1);
  });

  it("Should NOT transfer", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);

    const instance = allanCoin.connect(otherAccount);
    await expect(instance.transfer(owner.address, 1n))
      .to.be.revertedWith("Insufficient balance");
  });

  it("Should approve", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);

    await allanCoin.approve(otherAccount.address, 1n);

    const value = await allanCoin.allowance(owner.address, otherAccount.address);
    expect(value).to.equal(1n);
  });

  it("Should transfer from", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);
    const balanceOwnerBefore = await allanCoin.balanceOf(owner.address);
    const balanceOtherBefore = await allanCoin.balanceOf(otherAccount.address);

    await allanCoin.approve(otherAccount.address, 10n);

    const instance = allanCoin.connect(otherAccount);
    await instance.transferFrom(owner.address, otherAccount.address, 5n);

    const balanceOwnerAfter = await allanCoin.balanceOf(owner.address);
    const balanceOtherAfter = await allanCoin.balanceOf(otherAccount.address);
    const allowance = await allanCoin.allowance(owner.address, otherAccount.address);

    expect(balanceOwnerBefore).to.equal(1000n * 10n ** 18n);
    expect(balanceOwnerAfter).to.equal((1000n * 10n ** 18n) - 5n);
    expect(balanceOtherBefore).to.equal(0);
    expect(balanceOtherAfter).to.equal(5);
    expect(allowance).to.equal(5);
  });

  it("Should NOT transfer from (balance)", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);

    const instance = allanCoin.connect(otherAccount);
    await expect(instance.transferFrom(otherAccount.address, otherAccount.address, 1n))
      .to.be.revertedWith("Insufficient balance");
  });

  it("Should NOT transfer from (allowance)", async function () {
    const { allanCoin, owner, otherAccount } = await loadFixture(deployFixture);

    const instance = allanCoin.connect(otherAccount);
    await expect(instance.transferFrom(owner.address, otherAccount.address, 1n))
      .to.be.revertedWith("Insufficient allowance");
  });
});
