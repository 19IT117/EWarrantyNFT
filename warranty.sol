// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interface.sol";

contract WarrentyContract{

    updatedisIERC721 NFT;

    event Mint(address authority, address customer,string indexed MACaddress,uint256 tokenID);
    event WarrantyClaimed(uint tokenId,string reason);
    
    address Owner;
    constructor(address nftcontract){
        NFT = updatedisIERC721(nftcontract); 
        Owner = msg.sender;
    }
    
    modifier onlyOwner{
        require(msg.sender == Owner);
        _;
    }
    
    struct WarrentyDetails{
        uint256 purchasedtime;
        string MACaddress;
        bool warrantyTransferable;
        uint16 saled;
        address[] salehistory;
    }
    
    mapping (uint256 => WarrentyDetails) public WarrentyMapping;

    //setting warrenty status,should be called by another contract at time of delivery
    function startWarrenty(address buyer,string calldata MACaddress, bool transferable) public onlyOwner{
        uint tokenID = NFT.safeMint(buyer);
        WarrentyDetails storage s = WarrentyMapping[tokenID];
        s.purchasedtime = block.timestamp;
        s.MACaddress = MACaddress;
        s.warrantyTransferable = transferable;
        emit Mint(address(this),buyer,MACaddress,tokenID);
    }

    //only owner of product can call this function, no one else not even approved function
    function changeOwnership(uint256 tokenID, address to) public {
        require(NFT.ownerOf(tokenID) == msg.sender);
        NFT.safeTransferFrom(msg.sender,to,tokenID);
        WarrentyDetails storage s =WarrentyMapping[tokenID];
        s.saled++;
        s.salehistory.push(msg.sender);
    }

    function claimWarranty(uint tokenId, string calldata reason) public returns(bool){
        WarrentyDetails storage wd = WarrentyMapping[tokenId];
        require(msg.sender==NFT.ownerOf(tokenId),"You aren't owner");
        require(wd.purchasedtime+1000 > block.timestamp , "Timeline for warranty ended");
        require(wd.saled == 0 || wd.warrantyTransferable,"Warrenty ends as you sold the product");
        emit WarrantyClaimed(tokenId,reason);
        return true;
    }

    function tokenURI(uint tokenID) public view returns(string memory){
        return NFT.tokenURI(tokenID);
    }
}
