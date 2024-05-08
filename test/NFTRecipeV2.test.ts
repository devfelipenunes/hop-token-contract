import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("NFT Recipe", function () {
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

  // it("Should mint a token", async function () {
  //   const { nftRecipe, owner } = await loadFixture(deployFixture);

  //   console.log(await nftRecipe.mint("uri", { gasLimit: 5000000 }));
  //   // const overrides = {
  //   //   gasLimit: 5000000,
  //   // };

  //   // await nftRecipe.mint("uri", overrides);

  //   expect(await nftRecipe.uri(1)).to.equal("uri");
  // });
});
