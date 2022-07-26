// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VivoWarrentyNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    mapping (address => bool) authority;
    
    constructor() ERC721("VivoWarrentyNFT", "VWNFT") {}
    
    //URL will have metadata of product
    function _baseURI() internal pure override returns (string memory) {
        return "https://www.vivo.com/w.nft/";
    }

    modifier onlyAuthority{
        require(authority[msg.sender], "You aren't authorized contract");
        _;
    }
    
    function safeMint(address to) public onlyAuthority returns(uint256){
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        return tokenId;
    }

    function ChangeAuthority(address contractaddress,bool authorityStatus) public onlyOwner{
        authority[contractaddress]= authorityStatus;   
    }
}
