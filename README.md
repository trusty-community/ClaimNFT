# ClaimNFT Starter Kit

This repository contains a sample project that you can use as the starting point
for your ClaimNFT project.

This project is intended to be used with the Trusty support, but you should be
able to follow it by yourself by reading the README and exploring its
`contracts`, `tests`, `scripts` and `frontend` directories.

## Quick start

The first things you need to do are cloning this repository and installing its
dependencies:

```sh
git clone https://github.com/trusty-community/ClaimNFT.git
cd ClaimNFT
npm install
```

Once installed, let's run Hardhat's testing network:

```sh
npx hardhat node
```

Then, on a new terminal, go to the repository's root folder and run this to
deploy your contract:

```sh
npx hardhat run scripts/deploy.js --network localhost
```

Finally, we can run the frontend with:

```sh
cd frontend
npm install
npm start
```

Open [http://localhost:3000/](http://localhost:3000/) to see your Dapp. You will
need to have [Metamask](https://metamask.io) installed and listening to
`localhost 8545`.


## User Guide
This repository enables you to mint ClaimNFT, check it and suspend / activate or revoke it. The repository include the Dapp to use the smart-contract.
To use the Dapp you need to Metamask installed ([Setting up Metamask](https://hardhat.org/tutorial/boilerplate-project#how-to-use-it))
For the full article (only Italian) see [here](https://www.trusty.id/blog)

## Troubleshooting

- `Invalid nonce` errors: if you are seeing this error on the `npx hardhat node`
  console, try resetting your Metamask account. This will reset the account's
  transaction history and also the nonce. Open Metamask, click on your account
  followed by `Settings > Advanced > Reset Account`.

## Setting up your editor

[Hardhat for Visual Studio Code](https://hardhat.org/hardhat-vscode) is the official Hardhat extension that adds advanced support for Solidity to VSCode. If you use Visual Studio Code, give it a try!

## Getting help and updates

If you need help with this project, or with ClaimNFT in general, please contact us at info@trusty.id or through our [website](https://trusty.id).

For the latest news about Trusty, [follow us on Linkedin](https://www.linkedin.com/company/trustytrusty), and don't forget to star [our GitHub repository](https://github.com/trusty-community/ClaimNFT)!

Thanks to [Hardhat](https://github.com/NomicFoundation/hardhat)!

**Happy _building_!**

