// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

/**
 * @title 债务代币接口定义（IDebtToken）
 * @dev 定义了债务类代币的核心功能接口，
 * 包括查询余额、总供应量、铸造与销毁功能。
 */
interface IDebtToken {

    /**
     * @notice 查询指定账户的代币余额
     * @dev 返回账户当前持有的债务代币数量
     * @param account 要查询的账户地址
     * @return 该账户持有的债务代币数量
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @notice 获取代币的总发行量
     * @dev 返回当前所有已存在的债务代币总数
     * @return 当前总供应量
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice 为指定账户铸造代币
     * @dev 通常由合约的控制者或协议逻辑调用，
     *      向账户新增债务代币数量
     * @param account 接收新铸造代币的账户地址
     * @param amount 要铸造的代币数量
     */
    function mint(address account, uint256 amount) external;

    /**
     * @notice 为指定账户销毁代币
     * @dev 通常用于偿还债务或减少供应量，
     *      从账户余额中减少指定数量的代币
     * @param account 要销毁代币的账户地址
     * @param amount 要销毁的代币数量
     */
    function burn(address account, uint256 amount) external;
}