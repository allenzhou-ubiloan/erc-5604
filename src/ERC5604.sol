// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

import "./IERC5604.sol";

/// @author Allen Zhou
abstract contract ERC5604 is ERC721, IERC5604 {
    
    // Mapping from token ID to lien holder address.
    mapping(unit256 => address) private _tokenLienHolders;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC5604).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC5604-addLienHolder}.
     */
    function addLienHolder(
        uint256 tokenId, 
        address holder, 
        bytes calldata extraParams
    ) public virtual override(IERC165, ERC721) {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC5604: caller is not token owner or approved");
        require(_tokenLienHolders[tokenId] == address(0), "ERC5604: token lien holder existed");
        require(holder != address(0), "ERC5604: add lien to address(0)");

        _tokenLienHolders[tokenId] = holder;

        emit OnLienPlaced(tokenId, holder, extraParams);
    }

    /**
     * @dev See {IERC5604-removeLienHolder}.
     */
    function removeLienHolder(
        uint256 tokenId, 
        address holder, 
        bytes calldata extraParams
    ) public virtual override(IERC165, ERC721) {
        require(_tokenLienHolders[tokenId] == _msgSender(), "ERC5604: caller is not token lien holder");

        delete _tokenLienHolders[tokenId];

        emit OnLienRemoved(tokenId, holder, extraParams);
    }

    /**
     * @dev See {IERC5604-hasLien}.
     */
    function hasLien(
        uint256 tokenId, 
        address holder, 
        bytes calldata extraParams
    ) public view virtual override returns (bool) {
        return _lienHolderOf(tokenId) == holder;
    }

    /**
     * @dev Returns the lien holder of the `tokenId`. Does NOT revert if token doesn't exist.
     */
    function _lienHolderOf(uint256 tokenId) internal view virtual returns (address) {
        return _tokenLienHolders[tokenId];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        require(_tokenLienHolders[tokenId] == _msgSender() || _tokenLienHolders[tokenId] == address(0), "ERC5604: caller is not token lien holder");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        require(_tokenLienHolders[tokenId] == _msgSender() || _tokenLienHolders[tokenId] == address(0), "ERC5604: caller is not token lien holder");

        _safeTransfer(from, to, tokenId, data);
    }
}