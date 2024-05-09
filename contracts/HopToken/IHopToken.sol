// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IHopToken {
    function createNFTBeer(
        address nftBeer,
        uint tokenId,
        uint price
    ) external payable;

    function createBeerSale(address nftBeer, uint itemId) external payable;

    function fetchBeers() external view returns (Beer[] memory);

    function fetchMyBeers() external view returns (Beer[] memory);

    function fetchBeersCreated() external view returns (Beer[] memory);

    function createNFTRecipe(
        address nftRecipe,
        uint tokenId,
        uint price
    ) external payable;

    function createRecipeSale(address nftRecipe, uint itemId) external payable;

    function fetchRecipes() external view returns (Recipe[] memory);

    function fetchMyRecipes() external view returns (Recipe[] memory);

    function fetchRecipeCreated() external view returns (Recipe[] memory);

    struct Beer {
        uint itemId;
        address nftRecipe;
        uint tokenId;
        address payable seller;
        address payable owner;
        uint price;
        bool sold;
    }

    struct Recipe {
        uint itemId;
        address nftRecipe;
        uint tokenId;
        address payable creator;
        address payable owner;
        uint price;
        bool sold;
    }

    event NFTRecipeCreated(
        uint indexed itemId,
        address indexed nftRecipe,
        uint indexed tokenId,
        address seller,
        uint price
    );

    event NFTBeerCreated(
        uint indexed itemId,
        address indexed nftBeer,
        uint indexed tokenId,
        address seller,
        uint price
    );
}
