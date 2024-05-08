import { ethers } from "hardhat";

async function main() {
  const HopToken = await ethers.getContractFactory("HopToken");
  const hopToken = await HopToken.deploy();
  await hopToken.deployed();
  console.log(`HopToken deployed to ${hopToken.address}`);

  const NFTBeer = await ethers.getContractFactory("NFTBeer");
  const nftBeer = await NFTBeer.deploy(hopToken.address);
  await nftBeer.deployed();
  console.log(`NFTBeer deployed to ${nftBeer.address}`);

  const NFTRecipe = await ethers.getContractFactory("NFTRecipe");
  const nftRecipe = await NFTRecipe.deploy(hopToken.address);
  await nftRecipe.deployed();
  console.log(`NFTRecipe deployed to ${nftRecipe.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
