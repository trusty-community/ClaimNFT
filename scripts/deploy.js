// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.

const path = require("path");
require('dotenv').config()
const { ethers } = require("hardhat");


async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
      "gets automatically created and destroyed every time. Use the Hardhat" +
      " option '--network localhost'"
    );
  }

  // ethers is available in the global scope
  const pKey = process.env.PRIVATE_KEY;
  let deployer = {}
  if (pKey) {
    let provider = new ethers.providers.JsonRpcProvider();
    console.log("PRIVATE KEY ", pKey);
    deployer = await new ethers.Wallet(pKey, provider);
  } else {
    [deployer] = await ethers.getSigners();
  }
  // Connect a wallet

  //const 
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Claims = await ethers.getContractFactory("Claims", deployer);
  const claims = await Claims.deploy();
  await claims.deployed();

  console.log("Claims address:", claims.address);

  // We also save the contract's artifacts and address in the frontend directory
  saveFrontendFiles(claims);
}

function saveFrontendFiles(claims) {
  const fs = require("fs");
  const contractsDir = path.join(__dirname, "..", "frontend", "src", "contracts");

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    path.join(contractsDir, "contract-address.json"),
    JSON.stringify({ Claims: claims.address }, undefined, 2)
  );

  const ClaimsArtifact = artifacts.readArtifactSync("Claims");

  fs.writeFileSync(
    path.join(contractsDir, "Claims.json"),
    JSON.stringify(ClaimsArtifact, null, 2)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
