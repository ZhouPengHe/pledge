const {ethers} = require("hardhat");



let multiSignatureAddress = ["0x3D7155586d33a31851e28bd4Ead18A413Bc8F599",
                            "0xc3C6Ef79897Df94ddd86189A86BD9c5c7bB93Cf6",
                            "0x3B720fBacd602bccd65F82c20F8ECD5Bbb295c0a"];
let threshold = 2;


async function main() {

  const [deployerMax,,,,deployerMin] = await ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployerMax.address
  );

  console.log("Account balance:", (await deployerMax.getBalance()).toString());

  const multiSignatureToken = await ethers.getContractFactory("multiSignature");
  const multiSignature = await multiSignatureToken.connect(deployerMax).deploy(multiSignatureAddress, threshold);

  console.log("multiSignature address:", multiSignature.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });