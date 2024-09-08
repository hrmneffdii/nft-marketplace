// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Counters} from "./Counters.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Token
 * @author Herman effendi
 * @dev Implementation of an ERC721 token with additional functionality for managing items and URIs.
 */
contract Token is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    address public marketplace;

    struct Item {
        uint256 id;
        address creator;
        string uri;
    }

    mapping(uint256 => Item) public Items;

    /**
     * @dev Constructor that initializes the contract with a given marketplace address.
     */
    constructor(address _marketplace) ERC721("METAVERSE", "MV") Ownable(msg.sender) {
        marketplace = _marketplace;
    }

    /**
     * @dev Mints a new token with a specified URI and assigns it to the caller.
     * @param _uri The URI associated with the newly minted token.
     * @return The ID of the newly minted token.
     */
    function mint(string memory _uri) external returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        approve(marketplace, newItemId);

        Items[newItemId] = Item({
            id: newItemId,
            creator: msg.sender,
            uri: _uri
        });

        return newItemId;
    }

    /**
     * @dev Returns the URI of a token.
     * @param tokenId The ID of the token whose URI is to be retrieved.
     * @return The URI of the token.
     * @notice Overrides the `tokenURI` function from ERC721URIStorage to return the custom URI stored in the `Items` mapping.
     */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            _ownerOf(tokenId) != address(0),
            "ERC721URIStorage: URI query for nonexistent token"
        );
        return Items[tokenId].uri;
    }

    /**
     * @dev Updates the marketplace address.
     * @param _marketplace The new address of the marketplace contract.
     */
    function setMarketplace(address _marketplace) external onlyOwner{
        marketplace = _marketplace;
    }
}
