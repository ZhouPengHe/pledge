// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.

let oracleAddress = "0x3D7155586d33a31851e28bd4Ead18A413Bc8F599";
let swapRouter = "0xbe9c40a0eab26a4223309ea650dea0dd4612767e";
let feeAddress = "0xa5D1E71aC4cE6336a70E8a0cb1B6DFa87BccEf4c";
let multiSignatureAddress = "0xcdC5A05A0A68401d5FCF7d136960CBa5aEa990Dd";

const {ethers} = require("hardhat");

async function main() {

  // const [deployerMax,,,,deployerMin] = await ethers.getSigners();
  const [deployerMin,,,,deployerMax] = await ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployerMin.address
  );

  console.log("Account balance:", (await deployerMin.getBalance()).toString());

  const pledgePoolToken = await ethers.getContractFactory("PledgePool");
  const pledgeAddress = await pledgePoolToken.connect(deployerMin).deploy(oracleAddress,swapRouter,feeAddress, multiSignatureAddress);


  console.log("pledgeAddress address:", pledgeAddress.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });