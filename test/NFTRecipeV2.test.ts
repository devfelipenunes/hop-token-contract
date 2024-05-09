import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFT RecipeV3", function () {
  async function deployFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const HopToken = await ethers.getContractFactory("HopToken");
    const hopToken = await HopToken.deploy();

    // const NFTBeer = await ethers.getContractFactory("NFTBeer");
    // const nftBeer = await NFTBeer.deploy(hopToken.address);

    const NFTRecipe = await ethers.getContractFactory("NFTRecipeV2");
    const nftRecipe = await NFTRecipe.deploy(hopToken.address);
    const nftRecipeAddress = nftRecipe.address;

    return { owner, otherAccount, hopToken, nftRecipe, nftRecipeAddress };
  }

  it("Should mint a token", async function () {
    const { nftRecipe, owner } = await loadFixture(deployFixture);

    await nftRecipe.mint(0, { value: ethers.utils.parseEther("0.01") });
    const balance = await nftRecipe.balanceOf(owner.address, 0);
    const supply = await nftRecipe.currentSupply(0);

    console.log({ balance, supply });

    expect(balance).to.equal(1, "Cannot mint");
    expect(supply).to.equal(49, "Cannot mint");
  });
});
