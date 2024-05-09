// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface INFTBeer {
    function mint(string memory uri) external returns (uint);

    function setApprovalForAll(address operator, bool approved) external;
}
