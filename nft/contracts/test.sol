// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract Hcanft is ERC721, Ownable {
    using SafeMath for uint256;
    using Strings for uint256;

    uint256 public nftCounter;
    uint256 public tokenPrimaryPrice;
    uint256 public mintedTotalCost;

    string public baseURI;

    uint256 public constant MAX_ELEMENTS = 1e4;
    uint256 public constant MAX_MINTABLE = 20;
    uint256 internal constant PERCENT100 = 1e6; // 100%
    uint256 public reflection = 1e5; // 10%
    uint256 remainMintAmount = MAX_ELEMENTS;
    uint256 public startMintTime = 1645539742;

    mapping(address => uint256[]) public userCollections;

    uint256 private totalDividend;

    mapping(uint256 => uint256) private claimedDividends;

    // initialize contract while deployment with contract's collection name and token
    constructor() ERC721("Hcanft", "hnft") {
        tokenPrimaryPrice = 1.25 ether;
    }

    // CHM
    function mint(uint256 mintAmount_) payable external {
        // check if this function caller is not an zero address account
        require(msg.sender != address(0));
        require(msg.value >= tokenPrimaryPrice.mul(mintAmount_), "Low Funds");

        uint256 _total = totalSupply();
        require(mintAmount_ + _total <= MAX_ELEMENTS, "Max limit");
//        require(_total <= MAX_ELEMENTS, "Sold");
        require(mintAmount_ <= MAX_MINTABLE, "Exceeds number");

//        require(startMintTime <= block.timestamp, 'Mint will start on 2022-02-22 14:22 UTC');

        uint256 _mintedFee = (msg.value).mul(PERCENT100 - reflection).div(PERCENT100);
        uint256 _reflection = tokenPrimaryPrice.mul(reflection).div(PERCENT100);
        mintedTotalCost = mintedTotalCost.add(_mintedFee);

        for (uint i = 0; i < mintAmount_; i++) {
            nftCounter ++;
            require(!_exists(nftCounter), nftCounter.toString());

            _mint(msg.sender, nftCounter);
            userCollections[msg.sender].push(nftCounter);

            claimedDividends[nftCounter] = totalDividend;
            totalDividend += (_reflection / nftCounter);
        }
    }

    // CHM
    function mintFree(uint256 mintAmount_) onlyOwner external {
        // check if this function caller is not an zero address account
        require(msg.sender != address(0));

        uint256 _total = totalSupply();
        require(mintAmount_ + _total <= MAX_ELEMENTS, "Max limit");
//        require(_total <= MAX_ELEMENTS, "Sold");
//        require(mintAmount_ <= MAX_MINTABLE, "Exceeds number");

        //require(startMintTime <= block.timestamp, 'Mint will start on 2022-02-22 14:22 UTC');

        for (uint i = 0; i < mintAmount_; i++) {
            nftCounter ++;
            require(!_exists(nftCounter), nftCounter.toString());

            _mint(msg.sender, nftCounter);
            userCollections[msg.sender].push(nftCounter);

            claimedDividends[nftCounter] = totalDividend;
        }
    }

    function getTokenPrimaryPrice() public view returns (uint256) {
        return tokenPrimaryPrice;
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        super._transfer(from, to, tokenId);
        for (uint256 index = 0; index < userCollections[from].length; index++) {
            if (userCollections[from][index] == tokenId) {
                userCollections[from][index] = userCollections[from][userCollections[from].length - 1];
                userCollections[from].pop();
            }
        }
        userCollections[to].push(tokenId);
    }

    function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
        require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
        string memory _baseURI = baseURI;
        return string(abi.encodePacked(_baseURI, tokenId_.toString(), ".json"));
    }

    function totalSupply() public view returns (uint256) {
        return nftCounter;
    }

    function setBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function setTokenPrimaryPrice(uint256 tokenPrimaryPrice_) public onlyOwner {
        tokenPrimaryPrice = tokenPrimaryPrice_;
    }

    function setReflection(uint256 _reflection) public onlyOwner {
        reflection = _reflection;
    }

    function claimUserReward() public {
        require(viewUserReward(msg.sender) > 0 || msg.sender == owner(), 'Reward is 0.');
        uint256 amountOfRewards = viewUserReward(msg.sender);
        payable(msg.sender).transfer(amountOfRewards);
        if(msg.sender == owner()) {
            mintedTotalCost = 0;
        }
        uint256[] memory _userCollections = getUserCollections(address (msg.sender));

        uint256 _tEarned;
        for (uint i = 0; i < _userCollections.length; i++) {
            _tEarned = totalDividend - claimedDividends[_userCollections[i]];
            if (_tEarned > 0) {
                claimedDividends[_userCollections[i]] += _tEarned;
            }
        }
    }

    function viewUserReward(address user_) public view returns (uint256){
        uint256 result;
        if(user_ == owner()) {
            result = result.add(mintedTotalCost);
        }

        uint256[] memory _userCollections = getUserCollections(user_);

        uint256 _tEarned;
        for (uint i = 0; i < _userCollections.length; i++) {
            _tEarned = totalDividend - claimedDividends[_userCollections[i]];
            if (_tEarned > 0) {
                result += _tEarned;
            }
        }

        return result;
    }

    function getUserCollections(address user_) public view returns (uint256[] memory) {
        return userCollections[user_];
    }

    function withdrawFunds() public onlyOwner {
        require(msg.sender == owner(), "not owner");
        payable(msg.sender).transfer(mintedTotalCost);
        mintedTotalCost = 0;
    }

    function setStartMintTime(uint256 startMintTime_) public onlyOwner {
        startMintTime = startMintTime_;
    }

    function withdrawStuckMoney(address payable destination_, uint256 withdrawAmount_) public onlyOwner {
        require(address(this).balance - mintedTotalCost >= withdrawAmount_, "No stuck money or the withdrawAmount you want is too much");
        destination_.transfer(withdrawAmount_);
    }
}