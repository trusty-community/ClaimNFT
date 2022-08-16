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
contract Claims is Ownable, AccessControl, ERC721Holder, ERC721URIStorage {
    // Create a new role identifier for the minter role
    bytes32 public constant AUTHORITY_ROLE = keccak256("AUTHORITY_ROLE");
    mapping(uint256 => string) public claimStatus;
    using Counters for Counters.Counter;
    Counters.Counter private supply;

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
    /*
      Claims metadata format
      {
          "title": "Project Proof Badge Metadata",
          "type": "object",
          "properties": {
              "name": {
                  "type": "string",
                  "description": "Identifies the badge template to which this NFT represents",
              },
              "description": {
                  "type": "string",
                  "description": "Describes the asset to which this NFT represents",
              },
              "image": {
                  "type": "string",
                  "description": "A URI pointing to a resource with mime type image/* representing the asset to which this NFT represents. Consider making any images at a width between 320 and 1080 pixels and aspect ratio between 1.91:1 and 4:5 inclusive.",
              },
              "unit_id": {
                  "type": "integer",
                  "description": "Specifies the id of this unit within its kind",
              }
          }
      }
    */
    constructor() ERC721("Claims", "CLAIM") {
        _setupRole(AUTHORITY_ROLE, msg.sender);
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

    function revokeClaim(uint256 tokenId, string memory message) public onlyRole(AUTHORITY_ROLE) {
        claimStatus[tokenId] = "REVOKED";
        _burn(tokenId);
    }

    function suspendClaim(uint256 tokenId) public onlyRole(AUTHORITY_ROLE) {
        claimStatus[tokenId] = "SUSPENDED";

    }

    function activateClaim(uint256 tokenId) public onlyRole(AUTHORITY_ROLE) {
        claimStatus[tokenId] = "ACTIVE";
    }
}
