
pragma solidity ^0.8.3;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract KaiECOToken721 is ERC721, ERC721Enumerable, Ownable
 {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    address parentAddress;

    uint256[] tokensIdscreated;

    mapping (uint256 => string) idToNFTMapping;
    mapping(string => bool) tokenURIExists;
    constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol) {
    }
    
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
        return idToNFTMapping[tokenId];
    }

    function mintNFT(string memory _tokenUri) public returns(uint256) {
       // using erc 721 to creat NFT
       // mint will create NFT and send it to the address. 
        require(!tokenURIExists[_tokenUri], 'The token URI should be unique');
        tokenIds.increment();
        uint256 _id = tokenIds.current();
        _safeMint(msg.sender, _id); 
        tokensIdscreated.push(_id);
        tokenURIExists[_tokenUri] = true;
        idToNFTMapping[_id] = _tokenUri;
        return _id;
    }

    function updateNFT(uint256 _id, string memory _tokenUri) public onlyOwner{
        require(tokenIds.current() > _id, 'The token id should be less than total supply');
        idToNFTMapping[_id] = _tokenUri;
    }


    
    
}