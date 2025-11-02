# [Pledge系统文档](https://github.com/MetaNodeAcademy/ProjectBreakdown-Pledge) 
[Pledge前端代码](https://github.com/MetaNodeAcademy/ProjectBreakdown-Pledge/tree/main/pledge-fe) 
[Pledge后端代码](https://github.com/MetaNodeAcademy/ProjectBreakdown-Pledge/tree/main/pledge-backend) 
[Pledge合约代码](https://github.com/MetaNodeAcademy/ProjectBreakdown-Pledge/tree/main/pledgev2) 
[Pledge合约视频教程](https://k22zz.xetlk.com/s/1kYAcz) 
[Pledge后端视频教程](https://k22zz.xetlk.com/s/4bOGZv) 

## 一：系统概述
借贷是Defi领域非常重要的模块，Maker、Aave、Compound是当前借贷领域的三巨头。  
Maker: 抵押资产获取稳定币DAI  [详情](https://docs.makerdao.com/smart-contract-modules/dai-module)  
Aave: 加密货币借贷协议  [详情](https://aave.com/docs/developers/smart-contracts)  
Compound: 加密货币借贷协议  [详情](https://docs.compound.finance/#protocol-contracts)  
Pledge 是一个去中心化金融（DeFi）项目，旨在提供固定利率的借贷协议，主要服务于加密资产持有者。Pledge 旨在解决 DeFi 借贷市场中缺乏固定利率和固定期限融资产品的问题。传统的 DeFi 借贷协议通常采用可变利率，主要服务于短期交易者，而 Pledge 则专注于长期融资需求。以下是对 Pledge 项目的详细分析：

## 二：功能需求
### 2.1 核心功能
- **固定利率借贷**: Pledge 提供固定利率的借贷服务，减少利率波动带来的风险。
- **去中心化 Dex 交易**(核心)。

### 2.2 主要角色
- **借款人**: 可以抵押加密资产以获得稳定币，用于投资非加密资产。
- **贷款人**: 提供流动性，获得固定回报。

### 2.3 关键组件
- **智能合约**: 自动执行借贷协议，确保交易记录上链且不可篡改。
- **pToken/jToken**: 代表未来时间点的价值转移，用于借贷和清算。

## 三: 代码分析
PledgePool.sol 是 Pledge 项目的核心智能合约之一，主要功能包括：
### 3.1 Pool
- **创建和管理借贷池**: 包括设置借贷池的基本信息、状态管理等。
- **用户存款和取款**: 处理用户的借款和贷款操作，包括存款、取款、索赔等。
- **自动清算**: 根据设定的阈值自动触发清算操作，保护借贷双方的利益。
- **费用管理**: 设置和管理借贷费用，确保平台的可持续运营。

  ![whiteboard_exported_image](img.png)

## :four:  事件和函数
- **事件**:如 DepositLend、RefundLend、ClaimLend 等，用于记录用户操作。
- **函数**: 如 DepositLend、refundLend、claimLend 等，实现具体的业务逻辑。

## 四：操作说明

## 本地运行

```
npm install
npx hardhat compile
npx hardhat test
npx hardhat ignition deploy ./ignition/modules/PledgePool.js

```

## 部署 multiSignature 到 sepolia

敲黑板
!!! 需要先部署 multiSignature 到 sepolia ，然后 注意 那3管理员钱包地址，写你自己的，可以交互控制！！！
```js
// scripts/deploy/multiSignature.js
// 第五行代码开始！！！
let multiSignatureAddress = ["0x3D7155586d33a31851e28bd4Ead18A413Bc8F599",
                            "0xc3C6Ef79897Df94ddd86189A86BD9c5c7bB93Cf6",
                            "0x3B720fBacd602bccd65F82c20F8ECD5Bbb295c0a"];
let threshold = 2;
```

```shell
npx hardhat run scripts/deploy/multiSignature.js --network sepolia
```
这里，我们得到了一个多签名地址，然后 在 scripts/deploy/debtToken.js 中 使用这个地址
就叫 multiSignatureAddress

## 部署 debtToken 到 sepolia

敲黑板
！！！这里 multiSignatureAddress 取上面部署得到的地址！！！
```js
// scripts/deploy/debtToken.js
// 第10行代码开始！！！
let multiSignatureAddress = "0xa5D1E71aC4cE6336a70E8a0cb1B6DFa87BccEf4c";
```

```shell
npx hardhat run scripts/deploy/debtToken.js --network sepolia
```

## 部署 swapRouter 到 sepolia
npx hardhat run scripts/deploy/swapRouter.js --network sepolia

## 部署 pledgePool 到 sepolia
npx hardhat run scripts/deploy/pledgePool.js --network sepolia


```



WBNB:0xd0772b878adb5c739b878e2afa060cea4a3fbc14
https://sepolia.etherscan.io/address/0xd0772b878adb5c739b878e2afa060cea4a3fbc14#code

PancakeFactory
0x5e1B1049AB259cB09e341B4f0d9426896b89fA9f

PANCAKEROUTER 
0x3b75bC4e6dBAcd54023aFCB8dF0Bcd040086EabF
https://sepolia.etherscan.io/address/0x3b75bc4e6dbacd54023afcb8df0bcd040086eabf#code

multiSignature
0x1257F1804B73b8125f399A2c440763DF86FF6B50
https://sepolia.etherscan.io/address/0x1257f1804b73b8125f399a2c440763df86ff6b50#code

BscPledgeOracle
0xB574D61E7121320D708C6eC988c9CDEEc0cDDAEa
https://sepolia.etherscan.io/address/0xb574d61e7121320d708c6ec988c9cdeec0cddaea#code

PledgePool
0xbEd2F048532b859EA0272E87C07489ad7A1772DE
https://sepolia.etherscan.io/address/0xbed2f048532b859ea0272e87c07489ad7a1772de#code

DebtToken
Jpbtc 
0x3b80F1c05e331eb742Db0696038F349EEFEdae5d
https://sepolia.etherscan.io/address/0x3b80f1c05e331eb742db0696038f349eefedae5d#code

Jpbusd 
0x363a91fB59bEC3399a9f656A76304CDa9B34E66d
https://sepolia.etherscan.io/address/0x363a91fb59bec3399a9f656a76304cda9b34e66d



#### BSC TEST NETWORK CONTRACTS

- BUSD TOKEN : 0xE676Dcd74f44023b95E0E2C6436C97991A7497DA
- BTC TOKEN : 0xB5514a4FA9dDBb48C3DE215Bc9e52d9fCe2D8658
- DAI TOKEN : 0x490BC3FCc845d37C1686044Cd2d6589585DE9B8B
- BNB TOKEN : 0x0000000000000000000000000000000000000000 
  
- ORACLE ADDRESS: 0x272aCa56637FDaBb2064f19d64BC3dE64A85A1b2
- SWAP ADDRESS: 0xbe9c40a0eab26a4223309ea650dea0dd4612767e
- FEE ADDRESS： 0x0ff66Eb23C511ABd86fC676CE025Ca12caB2d5d4
- PLEDGE ADDRESS: 0x216f718A983FCCb462b338FA9c60f2A89199490c
- MULTISIGNATURE: 0xcdC5A05A0A68401d5FCF7d136960CBa5aEa990Dd