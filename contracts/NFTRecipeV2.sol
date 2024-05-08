// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract NFTRecipeV2 is Context, ERC721URIStorage {
    uint256 private _tokenIds;
    mapping(uint256 => uint256[]) private _royalties;

    address contractAddress;
    address owner;

    constructor(address hopTokenContract) ERC721("HopToken", "HT") {
        contractAddress = hopTokenContract;
        owner = _msgSender();
    }

    function mint(string memory uri) public returns (uint256) {
        uint256 tokenId = ++_tokenIds;

        _mint(owner, tokenId);
        _setTokenURI(tokenId, uri);

        mintSemiFungible(owner, tokenId);

        _royalties[tokenId] = [1, 2, 3, 4, 5];

        setApprovalForAll(contractAddress, true);

        return tokenId;
    }

    function mintSemiFungible(address to, uint256 tokenId) private {
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 12 ** 10;
        uint256[] memory ids = new uint256[](1);
        ids[0] = tokenId;
        address[] memory senders = new address[](1);
        senders[0] = address(this);
        ERC1155(contractAddress).safeBatchTransferFrom(
            address(this),
            to,
            ids,
            amounts,
            ""
        );
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public override(ERC721, IERC721) {
        require(
            _msgSender() == owner || operator != contractAddress || approved,
            "Cannot remove marketplace approval"
        );
        super.setApprovalForAll(operator, approved);
    }

    function isApprovedForAll(
        address account,
        address operator
    ) public view override(ERC721, IERC721) returns (bool) {
        return ERC1155(contractAddress).isApprovedForAll(account, operator);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override returns (bool) {
        return
            super.supportsInterface(interfaceId) ||
            ERC1155(contractAddress).supportsInterface(interfaceId);
    }

    function royalties(uint256 tokenId) public view returns (uint256[] memory) {
        return _royalties[tokenId];
    }
}
