// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTBeer is ERC721URIStorage {
    uint256 private _tokenIds;

    address contractAddress;
    address owner;

    constructor(address hopTokenAddress) ERC721("HopToken", "HT") {
        contractAddress = hopTokenAddress;
        owner = msg.sender;
    }

    function mint(string memory uri) public returns (uint) {
        uint tokenId = ++_tokenIds;

        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
        setApprovalForAll(contractAddress, true);

        return tokenId;
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public virtual override(ERC721, IERC721) {
        require(
            _msgSender() == owner || operator != contractAddress || approved,
            "Cannot remove marketplace approval"
        );
        _setApprovalForAll(_msgSender(), operator, approved);
    }
}
