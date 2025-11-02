// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MockOracle
 * @dev 模拟价格预言机合约，用于测试环境中设置和获取资产价格。
 */
contract MockOracle is Ownable {
    // 用于存储每个资产的小数位映射关系（可选）
    mapping(uint256 => uint256) internal decimalsMap;
    // 存储每个资产地址对应的价格
    mapping(address => uint256) internal priceMap;
    // 默认小数精度
    uint256 internal decimals = 1;

    /**
     * @dev 设置资产价格。
     * 仅合约所有者可调用。
     * @param asset 资产地址
     * @param price 资产价格
     */
    function setPrice(address asset,uint256 price) public onlyOwner {
        // 将资产地址对应的价格存储到映射中
        priceMap[asset] = price;
    }

    /**
     * @dev 获取单个资产的价格。
     * @param asset 资产地址
     * @return 资产对应的价格
     */
    function getPrice(address asset) public view returns (uint256) {
        // 返回该资产对应的价格
        return priceMap[asset];
    }

    /**
     * @dev 批量获取多个资产的价格。
     * @param assets 资产地址数组
     * @return prices 返回与输入资产对应的价格数组
     */
    function getPrices(uint256[]memory assets) public view returns (uint256[]memory) {
        // 获取输入数组长度
        uint256 len = assets.length;
        // 初始化价格数组
        uint256[] memory prices = new uint256[](len);
        // 循环获取每个资产的价格
        for (uint i=0;i<len;i++){
            // 通过 getUnderlyingPrice 获取资产价格
            prices[i] = getUnderlyingPrice(assets[i]);
        }
        // 返回价格数组
        return prices;
    }

    /**
     * @dev 获取基础资产价格（根据资产地址）。
     * @param underlying 基础资产地址（以 uint256 形式传入）
     * @return 基础资产对应的价格
     */
    function getUnderlyingPrice(uint256 underlying) public view returns (uint256) {
        // 返回该基础资产的价格（将 uint256 转换为 address）
        return priceMap[address(underlying)];
    }
}