# 🎵SoundMint - Music NFT Copyright Protection

## **Overview**
This project provides a **blockchain-based NFT platform** to help **new and independent music artists** secure ownership of their work using **NFTs (Non-Fungible Tokens)**. The platform allows artists to **mint unique NFTs for their music** and **register copyrights transparently** on the blockchain, ensuring **ownership verification, prevention of piracy, and direct monetization**.

## **Problem Statement**
New artists face significant challenges in **copyright protection, ownership verification, and monetization** of their music. Traditional copyright processes are **expensive, slow, and inaccessible**. Additionally, piracy and unauthorized use threaten their intellectual property.

### **Challenges Faced by Artists:**
- **Expensive & Slow Copyright Registration** – Traditional legal processes involve high costs and delays.
- **Ownership Disputes** – Proving ownership of a song is difficult when plagiarism occurs.
- **Music Piracy** – Unauthorized use and illegal downloads result in revenue loss.
- **Monetization Issues** – Streaming platforms take a large share of artists' earnings.

## **Solution: Blockchain & NFTs**
This project leverages **blockchain technology and NFTs** to create a **decentralized, cost-effective, and secure** system for copyright protection. The solution allows artists to:

1. **Mint NFTs for their music** – A unique, immutable digital certificate of ownership is created.
2. **Register Copyrights Transparently** – Ownership records are securely stored on the blockchain.
3. **Prevent Duplicate Registrations** – Ensures the same song is not minted twice.
4. **Enable Direct Monetization** – Artists can sell or license their music NFTs without intermediaries.

---

## **Smart Contract Implementation**
The **MusicNFT** smart contract is developed in **Solidity** and deployed on the **Ethereum blockchain**.

### **Key Features:**
✅ **ERC721 Standard** – Uses OpenZeppelin’s NFT standard for easy integration.  
✅ **Ownership Verification** – Stores metadata (song name, artist name, timestamp).  
✅ **Duplicate Prevention** – Ensures the same song is not minted twice.  
✅ **Event Emission** – Notifies when a new NFT is minted.  
✅ **Ownable Access Control** – Only artists can mint their NFTs.  

### **Smart Contract Code:**
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MusicNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    struct Song {
        string songName;
        string artistName;
        uint256 timestamp;
    }

    mapping(uint256 => Song) public songDetails;
    mapping(string => bool) private existingSongs;

    event MusicMinted(address indexed artist, uint256 tokenId, string songName, string artistName, uint256 timestamp);

    constructor() ERC721("MusicNFT", "MUSNFT") {}

    function mintMusicNFT(string memory songName, string memory artistName, string memory metadataURI) external {
        require(!existingSongs[songName], "This song is already registered as an NFT");

        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, metadataURI);

        songDetails[newTokenId] = Song(songName, artistName, block.timestamp);
        existingSongs[songName] = true;

        emit MusicMinted(msg.sender, newTokenId, songName, artistName, block.timestamp);
    }

    function getSongDetails(uint256 tokenId) external view returns (string memory, string memory, uint256) {
        require(_exists(tokenId), "Token ID does not exist");
        Song memory song = songDetails[tokenId];
        return (song.songName, song.artistName, song.timestamp);
    }
}
```

### **How the Smart Contract Works:**
1. **Artists Call `mintMusicNFT()`**  
   - Provide **song name, artist name, and metadata URI** (stored on IPFS).
   - A **new NFT is minted** and linked to their Ethereum wallet.
   - Prevents duplicate registrations of the same song.
   - Emits an **event with the NFT details**.

2. **Ownership Verification**  
   - `getSongDetails(tokenId)` allows **anyone** to verify the song’s **original creator and timestamp**.

3. **Secure & Immutable Data**  
   - Since blockchain records cannot be altered, **ownership is permanent**.
   - Storing the **metadata URI** ensures details (e.g., song file, album cover) remain accessible.

---

## **Deployment Steps**
1. **Set Up a Blockchain Environment**  
   - Use **Ethereum (Sepolia Testnet)** or **Polygon Mumbai** for deployment.  
   - Install **MetaMask** for wallet integration.  
   - Use **Remix IDE** or **Hardhat** for contract deployment.  

2. **Deploy the Smart Contract**  
   - Compile the contract using Remix or Hardhat.
   - Deploy on **Sepolia Testnet** using **Alchemy or Infura**.
   - Verify the contract on **Etherscan**.

3. **Store Metadata on IPFS** (Optional)  
   - Use **Pinata** or **Filecoin** to store song metadata.

4. **Build a Simple UI (Optional)**  
   - A frontend using **React + Web3.js** can be built for artists to mint NFTs easily.

---

## **Future Enhancements**
🔹 **Royalty Mechanism** – Implement revenue-sharing for secondary sales.  
🔹 **Auction & Marketplace** – Enable buying and selling of music NFTs.  
🔹 **Multi-Chain Support** – Deploy on multiple blockchain networks.  

---

## **Conclusion**
This **Music NFT Copyright Protection platform** provides **new artists with a decentralized, cost-effective, and transparent way** to secure their music ownership. By leveraging **blockchain and NFTs**, artists can protect their intellectual property, prevent unauthorized use, and explore **new monetization opportunities** without intermediaries.

Would you like a guide on integrating a frontend for this? 🚀
