// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ERC20Interface {
    /**
     * @notice 查询指定账户的代币余额
     * @dev 该函数是一个只读函数，不会修改区块链状态。
     * @param user 要查询余额的账户地址
     * @return 账户地址对应的代币余额（以最小单位计）
     */
    function balanceOf(address user) external view returns (uint256);
}