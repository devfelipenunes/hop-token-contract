import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFT Beer", function () {
  async function deployFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const HopToken = await ethers.getContractFactory("HopToken");
    const hopToken = await HopToken.deploy();

    const NFTBeer = await ethers.getContractFactory("NFTBeer");
    const nftBeer = await NFTBeer.deploy(hopToken.address);

    const NFTRecipe = await ethers.getContractFactory("NFTRecipe");
    const nftRecipe = await NFTRecipe.deploy(hopToken.address);

    return { nftBeer, owner, otherAccount, hopToken, nftRecipe };
  }

  it("Should mint a token", async function () {
    const { nftRecipe } = await loadFixture(deployFixture);

    await nftRecipe.mint("metadata uri");

    expect(await nftRecipe.tokenURI(1)).to.equal("metadata uri");
  });

  it("Can change approval", async function () {
    const { nftRecipe, otherAccount, owner } = await loadFixture(deployFixture);

    const instance = nftRecipe.connect(otherAccount);
    await instance.mint("metadata uri");
    await instance.setApprovalForAll(owner.address, false);

    expect(
      await nftRecipe.isApprovedForAll(otherAccount.address, owner.address)
    ).to.equal(false);
  });
});
