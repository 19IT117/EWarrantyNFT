// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC165 {
 function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface supportedFunctions{
    function tokenURI(uint tokenID) external view returns(string memory);
    function safeMint(address to) external returns(uint256);
}

interface updatedisIERC721 is IERC165,supportedFunctions{
    
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
