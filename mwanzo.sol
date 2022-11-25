// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Mwanzo is ERC721URIStorage, Ownable {
  
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    uint256 public cost = 0.05 ether;
    string[] imageUri = [
        "guud.json",
        "inspired.json",
        "racdup.json"
        
    ];

    constructor() ERC721("Mwanzo", "dNFT"){
    }

    function safeMint(address to) public payable{
        require(msg.value >= cost, "Please send more ether");
        uint256 current_tokenId = _tokenId.current();
        _safeMint(to, current_tokenId);
        _setTokenURI(current_tokenId, imageUri[0]);
    }

    function changeNft(address from, uint256 tokenId) public payable{
        require (balanceOf(from) > 0, "Need to have atleast 1 token to proceed");
        require(msg.value >= cost, "Please send more ether");
        uint256 newVal = checkStage(tokenId) + 1;
        string memory newURI = imageUri[newVal];
        _setTokenURI(tokenId, newURI);
    }

    function checkStage(uint256 tokenId) public view returns (uint256){
        string memory  uri = tokenURI(tokenId);
        if (keccak256(abi.encodePacked(uri)) == keccak256(abi.encodePacked("guud.json"))){
            return 0;
        } 
        else if (keccak256(abi.encodePacked(uri)) == keccak256(abi.encodePacked("inspired.json"))){
            return 1;
        }
        else if (keccak256(abi.encodePacked(uri)) == keccak256(abi.encodePacked("racdup.json"))){
            return 2;
        }   
    }

    function withdraw() public payable onlyOwner{
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }


}
