// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract NFTRecipe is ERC1155, ERC1155Burnable, ERC1155URIStorage, ERC2981 {
    uint256 private _recipeIds;
    uint256 private _beerIds;

    uint256 public constant RECIPE = 0;
    uint256 public constant BEER = 1;
    // uint256[] listIds = [RECIPE, BEER];
    // uint256[] listAmounts = [10 ** 27, 5];

    address private _royaltiesReceiver;
    uint256 public constant MAX_SUPPLY = 7777;
    uint256 public constant royaltiesPercentage = 5;

    uint public tokenPrice = 0.001 ether;

    address contractAddress;
    address payable public immutable owner;

    mapping(uint256 => string[]) tokenURIs;
    mapping(uint256 => RoyaltyInfo[]) public royaltyInfos;
    mapping(uint256 => address) public tokenOwners;

    // constructor(address marketplaceAddress) ERC1155("") {
    constructor() ERC1155("") {
        // contractAddress = marketplaceAddress;
        owner = payable(msg.sender);
    }

    // function mint(string[] memory URIs) public payable returns (uint) {
    function mintNFTRecipe(string memory URIs) public payable returns (uint) {
        uint recipeIds = ++_recipeIds;

        // for (uint i = 0; i < listIds.length; i++) {
        //     tokenURIs[listIds[i]] = [URIs[i]];
        //     _mint(msg.sender, listIds[i], listAmounts[i], "");
        // }
        tokenURIs[RECIPE] = [URIs];
        _mint(msg.sender, RECIPE, 10 ** 27, "");

        royaltyInfos[recipeIds].push(RoyaltyInfo(msg.sender, 100));
        tokenOwners[recipeIds] = msg.sender;

        return recipeIds;
    }

    function mintNFTBeer(string memory URIs) public payable returns (uint) {
        require(
            balanceOf(msg.sender, RECIPE) >= 1,
            "You must have one RECIPE token to mint BEER"
        );

        uint beerIds = ++_beerIds;
        // for (uint i = 0; i < listIds.length; i++) {
        //     tokenURIs[listIds[i]] = [URIs[i]];
        //     _mint(msg.sender, listIds[i], listAmounts[i], "");
        // }
        tokenURIs[BEER] = [URIs];
        _mint(msg.sender, BEER, 10 ** 27, "");

        _setDefaultRoyalty(tokenOwners[RECIPE], 10);
        // royaltyInfos[beerIds].push(RoyaltyInfo(msg.sender, 100));
        // tokenOwners[beerIds] = msg.sender;

        return beerIds;
    }

    function uri(
        uint256 tokenId
    ) public view override(ERC1155, ERC1155URIStorage) returns (string memory) {
        return tokenURIs[tokenId][tokenId % tokenURIs[tokenId].length];
    }

    function transferRecipe(address from, address to) external payable {
        // uint256 salePrice = msg.value;
        // uint256 totalRoyalties = (salePrice * royaltiesPercentage) / 100;

        _safeTransferFrom(from, to, RECIPE, 1, "");

        // payable(owner).transfer(salePrice - totalRoyalties);
    }

    function transferBeerWithRoyalties(
        address from,
        address to,
        uint256 amount
    ) external {
        address creator = tokenOwners[RECIPE];

        // require(_msgSender() == from, "You can only transfer your own token");

        // Verificar se o remetente possui pelo menos um token RECIPE
        // require(
        //     balanceOf(from, RECIPE) >= 1,
        //     "You must have at least one RECIPE token to transfer BEER"
        // );

        // require(
        //     balanceOf(from, BEER) >= amount,
        //     "You must have enough BEER tokens to transfer"
        // );

        // Transferir os tokens BEER
        _safeTransferFrom(from, to, BEER, amount, "");

        // Calcular e transferir as royalties para o criador
        uint256 totalRoyalties = (amount * royaltiesPercentage) / 100;
        _transferRoyalties(creator, totalRoyalties);
    }

    function _transferRoyalties(address recipient, uint256 amount) private {
        payable(recipient).transfer(amount);
    }

    // function royaltyInfo(
    //     uint256 _salePrice
    // ) external view returns (address receiver, uint256 royaltyAmount) {
    //     uint256 _royalties = (_salePrice * royaltiesPercentage) / 100;
    //     return (_royaltiesReceiver, _royalties);
    // }

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

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC1155, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
