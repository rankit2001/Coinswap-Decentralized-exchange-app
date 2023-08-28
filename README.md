Project: Building a Decentralized Exchange like Uniswap v1

This project involves creating a decentralized exchange (DEX) similar to Uniswap v1, where users can swap Ethereum (ETH) for a specified token and vice versa. The exchange will incorporate the following features:

Swap Functionality: Users can exchange ETH for the designated token and vice versa. A 1% fee is applied to all swaps, contributing to the liquidity pool.

Liquidity Provision: Users can add liquidity to the exchange by depositing both ETH and the specified token. In return, they will receive LP (Liquidity Provider) tokens that represent their share of the liquidity pool.

Fee Collection and Distribution: The 1% fee collected from each swap is distributed among the liquidity providers. This distribution is based on their proportionate contribution to the liquidity pool.

LP Token Management: LP token holders can burn their tokens. This process allows them to receive back their proportionate share of both ETH and the token from the liquidity pool.

The project's main objective is to provide a functional decentralized exchange with automated market-making (AMM) capabilities. Users can seamlessly swap between ETH and the specified token without relying on traditional order book models. Additionally, by adding liquidity to the exchange, users can earn fees and participate in the decentralized finance (DeFi) ecosystem.

The project includes the development of Ethereum smart contracts to manage the exchange's core functionality, including swap mechanics, liquidity provision, fee calculation, and LP token management. These smart contracts will be deployed on the Ethereum blockchain, providing a secure and trustless platform for users to trade and participate in liquidity provision.

To enhance the user experience, a simple user interface (UI) will be developed. This UI will allow users to interact with the smart contracts easily, facilitating token swaps and liquidity provision. The combination of well-designed smart contracts and a user-friendly interface will result in a functional and accessible decentralized exchange similar to Uniswap v1.


```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
