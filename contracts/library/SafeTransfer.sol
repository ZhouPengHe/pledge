// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./SafeErc20.sol";

/**
 * @title SafeTransfer
 * @notice 提供安全的 ERC20 与 ETH 转账方法封装
 * @dev 使用 SafeERC20 库确保转账不会因为返回值不规范的 ERC20 合约而失败。
 */
contract SafeTransfer {

    using SafeERC20 for IERC20;

    /// @notice 赎回事件，当资产从合约转出时触发
    /// @param recieptor 收款账户地址
    /// @param token 代币地址（若为 0 地址，则代表 ETH）
    /// @param amount 转账金额
    event Redeem(address indexed recieptor, address indexed token, uint256 amount);

    /**
     * @notice 将用户的资金转入合约（支持 ETH 与 ERC20）
     * @dev 
     *  - 若传入 token 为零地址（0x000...000），则表示转入 ETH；
     *  - 否则表示转入指定的 ERC20 代币；
     *  - ERC20 需提前调用 `approve` 授权。
     * @param token 代币地址（零地址代表 ETH）
     * @param amount 转账金额（仅当为 ERC20 时有效，ETH 会自动取 msg.value）
     * @return 实际转账金额
     */
    function getPayableAmount(address token, uint256 amount) internal returns (uint256) {
        // 若 token 为 0 地址，表示用户发送的是 ETH
        if (token == address(0)) {
            amount = msg.value; // 从 msg.value 获取实际发送的 ETH 金额
        }
            // 若为 ERC20 并且 amount > 0，则从 msg.sender 转入合约
        else if (amount > 0) {
            IERC20 oToken = IERC20(token);
            // 使用 SafeERC20 安全转账，防止因返回值异常导致失败
            oToken.safeTransferFrom(msg.sender, address(this), amount);
        }
        // 返回实际到账金额（ETH 或 ERC20）
        return amount;
    }

    /**
     * @notice 将资金从合约中安全转出（支持 ETH 与 ERC20）
     * @dev
     *  - 若 token 为 0 地址，则向目标账户转账 ETH；
     *  - 否则安全转账指定 ERC20；
     *  - 成功后触发 Redeem 事件。
     * @param recieptor 收款人地址（必须为 payable）
     * @param token 代币地址（零地址代表 ETH）
     * @param amount 转账金额
     */
    function _redeem(address payable recieptor, address token, uint256 amount) internal {
        // 若为 ETH，直接通过 transfer 转账
        if (token == address(0)) {
            recieptor.transfer(amount);
        }else {
            // 若为 ERC20，则调用 SafeERC20 的安全转账
            IERC20 oToken = IERC20(token);
            oToken.safeTransfer(recieptor, amount);
        }
        // 记录转账事件
        emit Redeem(recieptor, token, amount);
    }
}