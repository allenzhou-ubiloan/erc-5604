// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

/// @author Allen Zhou
interface IERC5604 is IERC721 {

    /// === Events ===

    /// @notice MUST be emitted when new lien is successfully placed.
    /// @param tokenId the token a lien is placed on.
    /// @param holder the holder of the lien.
    /// @param extraParams of the original request to add the lien.
    event OnLienPlaced(uint256 tokenId, address holder, bytes calldata extraParams);

    /// @notice MUST be emitted when an existing lien is successfully removed.
    /// @param tokenId the token a lien was removed from.
    /// @param holder the holder of the lien.
    /// @param extraParams of the original request to remove the lien.
    event OnLienRemoved(uint256 tokenId, address holder, bytes calldata extraParams);

    /// === CRUD ===

    /// @notice The method to place a lien on a token
    ///         it MUST throw an error if the same holder already has a lien on the same token.
    /// @param tokenId the token a lien is placed on.
    /// @param holder the holder of the lien
    /// @param extraParams extra data for future extension.
    function addLienHolder(uint256 tokenId, address holder, bytes calldata extraParams) external;

    /// @notice The method to remove a lien on a token
    ///         it MUST throw an error if the holder already has a lien.
    /// @param tokenId the token a lien is being removed from.
    /// @param holder the holder of the lien
    /// @param extraParams extra data for future extension.
    function removeLienHolder(uint256 tokenId, address holder, bytes calldata extraParams) external;

    /// @notice The method to query if an active lien exists on a token.
    ///         it MUST throw an error if the tokenId doesn't exist or is not owned.
    /// @param tokenId the token a lien is being queried for
    /// @param holder the holder about whom the method is querying about lien holding.
    /// @param extraParams extra data for future extension.
    function hasLien(uint256 tokenId, address holder, bytes calldata extraParams) external view returns (bool);
}