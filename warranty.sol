// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/19IT117/EWarrentyNFT/blob/main/nft.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract WarrentyContract{
    IERC721 NFT;
    VivoWarrentyNFT contractAdr;
    constructor(address nftcontract){
         NFT = IERC721(nftcontract);
        contractAdr = VivoWarrentyNFT(contractAdr);
    }
    
    struct WarrentyDetails{
        uint256 purchasedtime;
        uint256 endtime;
        uint32 saled;
        address[] salehistory;

    }
    mapping (uint256 => WarrentyDetails) public WarrentyMapping;

    //setting warrenty status,should be called by another contract at time of delivery
    function startWarrenty(uint tokenID) public {
        NFT.safeTransferFrom(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,msg.sender,tokenID);
        WarrentyDetails storage s =WarrentyMapping[tokenID];
        s.purchasedtime = block.timestamp;
        s.endtime = block.timestamp + 1000;
    }

    //only owner of product can call this function, no one else not even approved function
    function changeOwnership(uint256 tokenID, address to) public {
        require(NFT.ownerOf(tokenID) == msg.sender);
        NFT.safeTransferFrom(msg.sender,to,tokenID);
        WarrentyDetails storage s =WarrentyMapping[tokenID];
        s.saled++;
        s.salehistory.push(msg.sender);

    }

    function checkWarrenty(uint tokenID) public view returns(bool){
        if(WarrentyMapping[tokenID].endtime < block.timestamp)
            return false;
        else
            return true;
    }

    function claimWarrenty(uint tokenID) public {
        require(NFT.ownerOf(tokenID) == msg.sender && checkWarrenty(tokenID));
        //do something .....
    }

    function tokenURI(uint tokenID) public{
        contractAdr.tokenURI(tokenID);
    }
}
