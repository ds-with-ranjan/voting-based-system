# 🗳️ Smart Contract Voting System

A decentralized voting platform built using Solidity that allows users to vote securely and transparently on the Ethereum blockchain. Only one vote per address is allowed, and the admin can end the voting once it's complete.

---

## 🚀 Features

- 🗳️ One-person-one-vote rule
- 🔐 Only admin can start/end voting
- 📊 Transparent vote counting
- 🧾 Voter list stored on-chain
- ✅ Valid candidate check
- 📱 Can integrate with Web3 frontends (e.g. React + Metamask)

---

## 🛠️ Technologies Used

- **Solidity** (Smart contract language)
- **Remix IDE** or **Hardhat** (for development/deployment)
- **Ethereum** or any EVM-compatible blockchain
- **Metamask** (for testing or interacting with deployed contract)

---

## 📂 Contract Overview

### Functions:

| Function            | Description                                           |
|---------------------|-------------------------------------------------------|
| `vote(candidate)`   | Cast your vote for a valid candidate                  |
| `endVoting()`       | Ends the voting (only admin can call)                |
| `getVotes(candidate)`| Returns the vote count for a given candidate        |
| `getAllCandidates()`| Returns the list of all candidates                   |

---

## 📦 How to Deploy (Using Remix)

1. Go to [Remix IDE](https://remix.ethereum.org)
2. Create a new file `VotingSystem.sol` and paste the contract code
3. Compile the contract using Solidity 0.8.x
4. Deploy the contract with constructor input:  
   `["Alice", "Bob", "Charlie"]`
5. Interact with the contract using Remix UI

---

## ✅ Example Usage

```solidity
vote("Alice");       // Cast a vote for Alice
getVotes("Alice");   // View Alice's vote count
endVoting();         // Admin ends the voting process
```

This project represents the first step in bringing the power of blockchain to B2B supply chains, with a roadmap for continuous improvement and expansion to address the complex needs of modern global commerce.
## Contract Details: 
```
0x5a2ce363355e4c1dc5fd4ea3379cd47882c92bc9802239d3cff27cb832990f1c
```
![Screenshot 2025-05-01 225622](https://raw.githubusercontent.com/ds-with-ranjan/voting-based-system/refs/heads/main/Screenshot%202025-05-26%20143113.png)
