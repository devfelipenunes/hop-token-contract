// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract HopToken is ReentrancyGuard {
    uint256 private _itemIds;
    uint256 private _itemsSold;

    address payable owner;
    uint public listingPrice = 0.025 ether;

    constructor() {
        owner = payable(msg.sender);
    }

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

    mapping(uint => Recipe) public recipes; //item id => recipes
    mapping(uint => Beer) public beers; //item id => recipes

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

    function createNFTBeer(
        address nftBeer,
        uint tokenId,
        uint price
    ) public payable nonReentrant {
        require(price > 0, "Price cannot be zero");
        require(msg.value == listingPrice, "Value must be equal listing price");

        uint itemId = ++_itemIds;

        beers[itemId] = Beer(
            itemId,
            nftBeer,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        IERC721(nftBeer).transferFrom(msg.sender, address(this), tokenId);

        emit NFTBeerCreated(itemId, nftBeer, tokenId, msg.sender, price);
    }

    function createBeerSale(
        address nftBeer,
        uint itemId
    ) public payable nonReentrant {
        uint price = beers[itemId].price;
        uint tokenId = beers[itemId].tokenId;

        require(
            msg.value == price,
            "Please submit the asking price in order to complete purchase"
        );

        beers[itemId].seller.transfer(msg.value);

        IERC721(nftBeer).transferFrom(address(this), msg.sender, tokenId);

        beers[itemId].owner = payable(msg.sender);
        beers[itemId].sold = true;

        _itemsSold++;
        payable(owner).transfer(listingPrice);
    }

    function fetchBeers() public view returns (Beer[] memory) {
        uint totalItemCount = _itemIds;
        uint unsoldItemCount = totalItemCount - _itemsSold;

        Beer[] memory items = new Beer[](unsoldItemCount);
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (beers[i].owner == address(0) && !beers[i].sold) {
                items[currentIndex] = beers[i];
                ++currentIndex;
            }
        }

        return items;
    }

    function fetchMyBeers() public view returns (Beer[] memory) {
        uint totalItemCount = _itemIds;
        uint itemCount = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (beers[i].owner == msg.sender) {
                ++itemCount;
            }
        }

        Beer[] memory items = new Beer[](itemCount);
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (beers[i].owner == msg.sender) {
                items[currentIndex] = beers[i];
                ++currentIndex;
            }
        }

        return items;
    }

    function fetchBeersCreated() public view returns (Beer[] memory) {
        uint totalItemCount = _itemIds;
        uint itemCount = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (beers[i].seller == msg.sender) {
                ++itemCount;
            }
        }

        Beer[] memory items = new Beer[](itemCount);
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (beers[i].seller == msg.sender) {
                items[currentIndex] = beers[i];
                ++currentIndex;
            }
        }

        return items;
    }

    // RECIPE

    function createNFTRecipe(
        address nftRecipe,
        uint tokenId,
        uint price
    ) public payable nonReentrant {
        require(price > 0, "Price cannot be zero");
        require(msg.value == listingPrice, "Value must be equal listing price");

        uint itemId = ++_itemIds;

        recipes[itemId] = Recipe(
            itemId,
            nftRecipe,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        IERC721(nftRecipe).transferFrom(msg.sender, address(this), tokenId);

        emit NFTRecipeCreated(itemId, nftRecipe, tokenId, msg.sender, price);
    }

    function createRecipeSale(
        address nftRecipe,
        uint itemId
    ) public payable nonReentrant {
        uint price = recipes[itemId].price;
        uint tokenId = recipes[itemId].tokenId;

        require(
            msg.value == price,
            "Please submit the asking price in order to complete purchase"
        );

        recipes[itemId].creator.transfer(msg.value);

        IERC721(nftRecipe).transferFrom(address(this), msg.sender, tokenId);

        recipes[itemId].owner = payable(msg.sender);
        recipes[itemId].sold = true;

        _itemsSold++;
        payable(owner).transfer(listingPrice);
    }

    function fetchRecipes() public view returns (Recipe[] memory) {
        uint totalItemCount = _itemIds;
        uint unsoldItemCount = totalItemCount - _itemsSold;

        Recipe[] memory items = new Recipe[](unsoldItemCount);
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (recipes[i].owner == address(0) && !recipes[i].sold) {
                items[currentIndex] = recipes[i];
                ++currentIndex;
            }
        }

        return items;
    }

    function fetchMyRecipes() public view returns (Recipe[] memory) {
        uint totalItemCount = _itemIds;
        uint itemCount = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (recipes[i].owner == msg.sender) {
                ++itemCount;
            }
        }

        Recipe[] memory items = new Recipe[](itemCount);
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (recipes[i].owner == msg.sender) {
                items[currentIndex] = recipes[i];
                ++currentIndex;
            }
        }

        return items;
    }

    function fetchRecipeCreated() public view returns (Recipe[] memory) {
        uint totalItemCount = _itemIds;
        uint itemCount = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (recipes[i].creator == msg.sender) {
                ++itemCount;
            }
        }

        Recipe[] memory items = new Recipe[](itemCount);
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; ++i) {
            if (recipes[i].creator == msg.sender) {
                items[currentIndex] = recipes[i];
                ++currentIndex;
            }
        }

        return items;
    }
}
