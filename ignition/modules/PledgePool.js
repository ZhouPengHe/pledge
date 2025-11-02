// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("PledgePoolModule", (m) => {
    // ==========================这部分参数记得替换=============================
    const oracle = "0x481a65e50522602f6f920E6b797Df85b6182f948";
    const swapRouter = "0x03fb15c1Bbe875f3869D7b5EAAEB31111deA876F";
    const feeAddress = "0x03fb15c1Bbe875f3869D7b5EAAEB31111deA876F";
    const multiSignature = "0x03fb15c1Bbe875f3869D7b5EAAEB31111deA876F";
// ==========================这部分参数记得替换=============================
    const pledgePool = m.contract(
        "PledgePool",
        [oracle, swapRouter, feeAddress, multiSignature],
        {}
    );

    return { pledgePool };
});