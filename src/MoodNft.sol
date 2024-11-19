// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {

    error MoodNft_CantFlipMoodNotOwner();
    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum MOOD{
        HAPPY,
        SAD
    }

    mapping (uint256 => MOOD) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("MoodNft", "MN") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    function mintNft() public{
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = MOOD.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender)){
            revert MoodNft_CantFlipMoodNotOwner();
        }

        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }else{
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function baseURI() internal pure returns(string memory){
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == MOOD.HAPPY){
            imageURI = s_happySvgImageUri;
        }else {
            imageURI = s_sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                        '{"name": "',
                        name(),
                        '", "description": "An NFT that reflects the mood of the owner, 100% on Chain!", "attributes": [{"trait_type": "moodiness","value": 100}], "image": "', imageURI, '"}'
                        )
                    )
                )
            )
        );

    }
}

// string.concat() - it connects two strings. how to use it is 
// the needed strings are enclosed in a single quotations, use comma to add the string needed to be concated
// this works the same as abi.encodePacked()
// fs_permission - allows permissions that can be done in the console by foundry


