// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC165 {
 function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface supportedFunctions{
    function tokenURI(uint tokenID) external view returns(string memory);
}

interface IERC721 is IERC165,supportedFunctions{
    
    event Transfer(address from,address to,uint256 tokenId);
    event Approval(address owner,address approved,uint256 tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
}

contract WarrentyContract{
    IERC721 NFT;
   
    constructor(address nftcontract){
        NFT = IERC721(nftcontract); 
    }
    
    struct WarrentyDetails{
        uint256 purchasedtime;
        uint256 endtime;
        uint32 saled;
        address[] salehistory;

    }
    mapping (uint256 => WarrentyDetails) public WarrentyMapping;

    //setting warrenty status,should be called by another contract at time of delivery
    function startWarrenty(uint tokenID) public payable{
        NFT.safeTransferFrom(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,msg.sender,tokenID);
        //contractAdr.safeTransferFrom0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,msg.sender,tokenID);
        WarrentyDetails storage s =WarrentyMapping[tokenID];
        s.purchasedtime = block.timestamp;
        s.endtime = block.timestamp + 1000;
    }

    //only owner of product can call this function, no one else not even approved function
    function changeOwnership(uint256 tokenID, address to) public {
        require(NFT.ownerOf(tokenID) == msg.sender);
        //NFT.safeTransferFrom(msg.sender,to,tokenID);
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

    function claimWarrenty(uint tokenID) public view{
        require(NFT.ownerOf(tokenID) == msg.sender && checkWarrenty(tokenID));
        //do something .....
    }

    function tokenURI(uint tokenID) public view returns(string memory){
        return NFT.tokenURI(tokenID);
    }
}
