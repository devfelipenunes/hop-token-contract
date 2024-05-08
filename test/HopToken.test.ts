import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("HopToken", function () {
  async function deployFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const HopToken = await ethers.getContractFactory("HopToken");
    const hopToken = await HopToken.deploy();
    const hopTokenAddress = await hopToken.address;

    const NFTRecipe = await ethers.getContractFactory("NFTRecipe");
    const nftRecipe = await NFTRecipe.deploy(hopTokenAddress);
    const nftRecipeAddress = await nftRecipe.address;

    return {
      hopToken,
      hopTokenAddress,
      nftRecipe,
      nftRecipeAddress,
      owner,
      otherAccount,
    };
  }

  it("Should fetch items", async function () {
    const { hopToken, nftRecipeAddress, nftRecipe } = await loadFixture(
      deployFixture
    );

    console.log("hopToken", hopToken.address);
    console.log("nftRecipe", nftRecipeAddress);
  });
});
