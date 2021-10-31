// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

// inherit imported contracts
contract MyNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["red", "green", "blue", "yellow", "pink"];
    string[] secondWords = ["car", "blanket","couch", "computer", "chair"];
    string[] thirdWords = ["walking", "driving", "sleeping", "forging", "drinking"];

    event NewNFTMinted(address sender, uint256 tokenId);

    // pass name of nft token and symbol
    constructor() ERC721("TravelNFT", "RBK") {
        console.log("This is my NFT contract.");
    }

    function getFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function getSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function getThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // how users get NFT
    function makeNFT() public {
        // starts at 0
        uint256 newItemId = _tokenIds.current();

        string memory first = getFirstWord(newItemId);
        string memory second = getSecondWord(newItemId);
        string memory third = getThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

        // base64 encode JSON
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "Collection of travel NFTs", "image": "data:image/svg+xml;base64,',
                        // base64 svg
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // set up string
        string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        //mint to sender
        _safeMint(msg.sender, newItemId);

        //set data
        _setTokenURI(newItemId, finalTokenUri);
        console.log("NFT %s has been minted to %s", newItemId, msg.sender);

        //increase count
        _tokenIds.increment();
        emit NewNFTMinted(msg.sender, newItemId);
    }
}