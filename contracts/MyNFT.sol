// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import "hardhat/console.sol";

// inherit imported contracts
contract MyNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // pass name of nft token and symbol
    constructor() ERC721("TravelNFT", "RBK") {
        console.log("This is my NFT contract.");
    }

    // how users get NFT
    function makeNFT() public {
        // starts at 0
        uint256 newItemId = _tokenIds.current();

        //mint to sender
        _safeMint(msg.sender, newItemId);

        //set data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/XNR7");
        console.log("NFT %s has been minted to %s", newItemId, msg.sender);

        //increase count
        _tokenIds.increment();
    }
}