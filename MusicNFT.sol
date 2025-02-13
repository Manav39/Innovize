// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter; 

    struct Song {
        string songName;
        string artistName;
        uint256 timestamp;
    }

    mapping(uint256 => Song) public songDetails; // Stores song metadata
    mapping(bytes32 => bool) private existingSongs; // Prevents duplicate song minting
    mapping(uint256 => bool) private _mintedTokens; // Tracks minted tokens

    event MusicMinted(address indexed artist, uint256 tokenId, string songName, string artistName, uint256 timestamp);

    constructor() ERC721("MusicNFT", "MUSNFT") Ownable(msg.sender) {}

    /// @notice Mint an NFT for a music track
    /// @param songName The name of the song
    /// @param artistName The name of the artist
    /// @param metadataURI The IPFS URL of the song metadata
    function mintMusicNFT(string memory songName, string memory artistName, string memory metadataURI) external {
        bytes32 songHash = keccak256(abi.encodePacked(songName, artistName)); // Generate a unique song hash
        require(!existingSongs[songHash], "This song is already registered as an NFT");

        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, metadataURI);

        songDetails[newTokenId] = Song(songName, artistName, block.timestamp);
        existingSongs[songHash] = true;
        _mintedTokens[newTokenId] = true; // Mark token as minted

        emit MusicMinted(msg.sender, newTokenId, songName, artistName, block.timestamp);
    }

    /// @notice Retrieve song details by NFT ID
    /// @param tokenId The NFT token ID
    /// @return songName, artistName, and timestamp of minting
    function getSongDetails(uint256 tokenId) external view returns (string memory, string memory, uint256) {
        require(_mintedTokens[tokenId], "Token ID does not exist");
        Song memory song = songDetails[tokenId];
        return (song.songName, song.artistName, song.timestamp);
    }
}
