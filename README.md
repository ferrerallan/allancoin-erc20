
# Allancoin ERC20 Token

## Description

The Allancoin ERC20 project is designed to create a cryptocurrency token adhering to the ERC20 standard using Solidity and TypeScript. This Token reserves 1% of all transactions for a instituition of charity, that can be selected by votes of all participants. This repository includes the smart contract code, testing framework, and deployment scripts necessary for the creation and management of the token.

## Requirements

- Node.js v14 or higher
- npm v6 or higher
- Hardhat v2.6.0 or higher
- TypeScript v4.3 or higher

## Mode of Use

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ferrerallan/allancoin-erc20.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd allancoin-erc20
   ```
3. **Install the dependencies:**
   ```bash
   npm install
   ```
4. **Compile the smart contracts:**
   ```bash
   npx hardhat compile
   ```
5. **Run the tests:**
   ```bash
   npx hardhat test
   ```
6. **Deploy the contract to a network (e.g., Rinkeby):**
   ```bash
   npx hardhat run scripts/deploy.ts --network rinkeby
   ```

## Project Structure

- **contracts/**: Contains the Solidity smart contract code for Allancoin.
- **test/**: Includes test scripts to verify the functionality of the smart contracts.
- **scripts/**: Deployment scripts to deploy the smart contracts to a blockchain network.
- **artifacts/**: Generated artifacts after compiling the smart contracts.
- **typechain-types/**: TypeScript types generated from the smart contracts.

## Key Features

- **ERC20 Compliance**: Allancoin adheres to the ERC20 token standard, ensuring compatibility with existing ERC20 infrastructure.
- **Minting**: Allows new tokens to be minted by authorized addresses.
- **Burning**: Tokens can be burned, reducing the total supply.
- **Testing**: Comprehensive test suite to ensure the robustness of the smart contracts.

