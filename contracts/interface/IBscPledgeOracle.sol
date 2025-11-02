// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

// BSC 质押预言机接口
interface IBscPledgeOracle {

    /**
     * @dev 获取指定资产的价格
     * @param asset 资产地址
     * @return 返回资产价格的整数值（放大1e8倍），若未设置或合约暂停则返回0
     */
    function getPrice(address asset) external view returns (uint256);

    /**
     * @dev 根据 cToken 编号获取其对应的基础资产价格
     * @param cToken cToken的索引编号
     * @return 返回基础资产价格（放大1e8倍）
     */
    function getUnderlyingPrice(uint256 cToken) external view returns (uint256);

    /**
     * @dev 批量获取多个资产的价格
     * @param assets 资产地址数组
     * @return 返回对应资产价格数组（每个价格放大1e8倍）
     */
    function getPrices(uint256[] calldata assets) external view returns (uint256[] memory);
}