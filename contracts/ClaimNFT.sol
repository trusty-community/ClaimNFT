//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

// We import this library to be able to use console.log
import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// This is the main building block for smart contracts.
contract Claims is ERC721URIStorage, Ownable, AccessControl {
    // Create a new role identifier for the minter role
    bytes32 public constant AUTHORITY_ROLE = keccak256("AUTHORITY_ROLE");
    mapping(uint256 => string) public claimStatus;
    using Counters for Counters.Counter;
    Counters.Counter private supply;
    //Declare an Event
    event UpdatedStatus(
        uint256 indexed tokenId,
        string newStatus,
        string tokenURI
    );

    //I need to insert this to inherit ERC1155 and ERC1155Holder at the same time
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /* already included in ERC721.sol
    bytes4 private constant _InterfaceId_ERC721Metadata = 0x5b5e139f;
    bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
    */
   
    constructor() ERC721("ClaimNFT", "CLAIM") {
        _setupRole(AUTHORITY_ROLE, msg.sender);
        //mint(msg.sender, "");
        //claimStatus[1] = "NOT DEFINED";
    }

    modifier onlyCA() {
        require(isCA(msg.sender), "Caller is not a Cartification Authority");
        _;
    }

    function isCA(address account) public view returns (bool) {
        return hasRole(AUTHORITY_ROLE, account);
    }

    function addMinter(address account) public onlyOwner returns (bool) {
        require(!isCA(account), "account is already a Certification Authority");
        grantRole(AUTHORITY_ROLE, account);
        return true;
    }

    function removeMinter(address account) public onlyOwner returns (bool) {
        require(isCA(account), "account is not a Certification Authority");
        revokeRole(AUTHORITY_ROLE, account);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(!true, "ERC721: token transfer disabled");
        super._transfer(from, to, tokenId);
    }

    //Basic mint function with a max supply, you can't mint higher than this
    function mint(address _recipient, string memory _tokenURI)
        public
        onlyRole(AUTHORITY_ROLE)
    {
        supply.increment();
        uint256 newItemId = supply.current();
        _mint(_recipient, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        claimStatus[newItemId] = "ACTIVE";
    }

    function revokeClaim(uint256 tokenId) public onlyRole(AUTHORITY_ROLE) {
        claimStatus[tokenId] = "REVOKED";
        emit UpdatedStatus(tokenId, "REVOKED", tokenURI(tokenId));
    }

    function suspendClaim(uint256 tokenId) public onlyRole(AUTHORITY_ROLE) {
        claimStatus[tokenId] = "SUSPENDED";
        emit UpdatedStatus(tokenId, "SUSPENDED", tokenURI(tokenId));
    }

    function activateClaim(uint256 tokenId) public onlyRole(AUTHORITY_ROLE) {
        claimStatus[tokenId] = "ACTIVE";
        emit UpdatedStatus(tokenId, "ACTIVE", tokenURI(tokenId));
    }

    function isClaimNFT() public returns (bool) {
        return true;
    }

    function checkStatus(uint256 tokenId) public view returns (string memory) {
        return claimStatus[tokenId];
    }
}
