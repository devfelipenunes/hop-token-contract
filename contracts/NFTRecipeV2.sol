// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract NFTRecipe is ERC1155, ERC1155Burnable, ERC1155URIStorage {
    uint256 private _recipeIds;

    uint256 public constant RECIPE = 0;
    uint256 public constant ROYALTY = 1;
    uint256[] listIds = [RECIPE, ROYALTY];
    uint256[] listAmounts = [10 ** 27, 5];

    uint public tokenPrice = 0.001 ether;

    address contractAddress;
    address payable public immutable owner;

    mapping(uint256 => string[]) tokenURIs;

    constructor(address marketplaceAddress) ERC1155("") {
        // constructor() ERC1155("") {
        contractAddress = marketplaceAddress;
        owner = payable(msg.sender);
    }

    function mint(string[] memory URIs) public returns (uint) {
        uint recipeIds = ++_recipeIds;

        for (uint i = 0; i < listIds.length; i++) {
            tokenURIs[listIds[i]] = [URIs[i]];
            _mint(msg.sender, listIds[i], listAmounts[i], "");
        }

        return recipeIds;
    }

    function uri(
        uint256 tokenId
    ) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
        return tokenURIs[tokenId][tokenId % tokenURIs[tokenId].length];
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public override(ERC1155) {
        require(
            _msgSender() == owner || operator != contractAddress || approved,
            "Cannot remove marketplace approval"
        );
        _setApprovalForAll(_msgSender(), operator, approved);
    }
}
