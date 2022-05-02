// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import Open Zepplin contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./rarible/contracts/LibPart.sol";
import "./rarible/contracts/LibRoyaltiesV2.sol";
import "./rarible/contracts/RoyaltiesV2.sol";
import "./rarible/contracts/impl/AbstractRoyalties.sol";
import "./rarible/contracts/impl/RoyaltiesV2Impl.sol";

contract DNFT is ERC721Enumerable, Ownable, RoyaltiesV2Impl {

    using Strings for uint256;
    using Counters for Counters.Counter;
    //configuration
    string baseURI;
    string public baseExtension = ".json";

    //set the cost to mint each NFT
    uint256 public cost = 0.00 ether;

    //set the max supply of NFT's
    uint256 public maxSupply = 100;

    //set the maximum number an address can mint at a time
    uint256 public maxMintAmount = 1;

    //is the contract paused from minting an NFT
    bool public paused = false;

    //are the NFT's revealed (viewable)? If true users can see the NFTs. 
    //if false everyone sees a reveal picture
    bool public revealed = true;

    //the uri of the not revealed picture
    string public notRevealedUri;

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    mapping(address => uint256) public blanaces;

    mapping(uint256 => string) private tokenURIs;

    uint256 public totalBalance;
    //create two URIs. 
    //the contract will switch between these two URIs
    
    constructor(string memory _name,
                string memory _symbol,
                string memory _initBaseURI,
                string memory _initNotRevealedUri
            ) ERC721(_name, _symbol) {
                setBaseURI(_initBaseURI);
                setNotRevealedURI(_initNotRevealedUri);
            }
    
    
    //function allows you to mint an NFT token
    function mint(uint256 _mintAmount) public payable {
        uint256 supply = totalSupply();
        require(!paused);
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require(supply + _mintAmount <= maxSupply);

        if (msg.sender != owner()) {
        require(msg.value >= cost * _mintAmount);
        }
        blanaces[msg.sender] += msg.value;
        totalBalance += msg.value;
        for (uint256 i = 1; i <= _mintAmount; i++) {
        _safeMint(msg.sender, supply + i);
        }
    }
    //function returns the owner 
    function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
        tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
    //the token URI function will contain the logic to determine what URI to show
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
    {
        string memory currentURI;
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        if(revealed == false) {
            return notRevealedUri;
        }
        currentURI = bytes(tokenURIs[tokenId]).length > 0
            ? tokenURIs[tokenId]
            : _baseURI();
        
        return bytes(currentURI).length > 0
            ? string(abi.encodePacked(currentURI, tokenId.toString(), baseExtension))
            : "";
    }

    // set new URI for specific token by owner
    function setNewURI(uint256 tokenId, string memory newURI) public onlyOwner
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        require(
            bytes(newURI).length > 0,
            "new URI is empty"
        );
        tokenURIs[tokenId] = newURI;
    } 
    //only owner
    function reveal() public onlyOwner {
        revealed = true;
    }

    //set the cost of an NFT
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    //set the max amount an address can mint
    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    //set the not revealed URI on IPFS
    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    //set the base URI on IPFS
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }


    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    //pause the contract and do not allow any more minting
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    //configure royalties for Rariable
    function setRoyalties(uint _tokenId, address payable _royaltiesRecipientAddress, uint96 _percentageBasisPoints) public onlyOwner {
        LibPart.Part[] memory _royalties = new LibPart.Part[](1);
        _royalties[0].value = _percentageBasisPoints;
        _royalties[0].account = _royaltiesRecipientAddress;
        _saveRoyalties(_tokenId, _royalties);
    }

    //configure royalties for Mintable using the ERC2981 standard
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
        //use the same royalties that were saved for Rariable
        LibPart.Part[] memory _royalties = royalties[_tokenId];
        if(_royalties.length > 0) {
        return (_royalties[0].account, (_salePrice * _royalties[0].value) / 10000);
        }
        return (address(0), 0);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC721Enumerable) returns (bool) {
        if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
            return true;
        }
        if(interfaceId == _INTERFACE_ID_ERC2981) {
            return true;
        }
        return super.supportsInterface(interfaceId);
    }

    // receive() external payable {}
}   // i want have more discussion at https://join.skype.com/invite/GfTgpROchzA4