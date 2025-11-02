// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "../interface/ERC20Interface.sol";

/**
 * @title SafeToken
 * @dev 针对 ERC20 Token 操作的安全封装库。
 * 通过底层 `call` 调用代币合约函数，并验证返回结果是否为 true，
 * 避免因部分代币未返回 bool 导致的兼容性问题。
 *
 * 可在合约中使用：`using SafeToken for address;`
 * 然后以 `token.safeTransfer(to, amount)` 的方式调用。
 */
library SafeToken {

    /**
     * @notice 获取当前合约地址所持有的某个代币余额。
     * @param token 目标代币合约地址
     * @return uint256 当前合约的代币余额
     */
    function myBalance(address token) internal view returns (uint256) {
        // 调用 ERC20 的 balanceOf(address(this)) 方法，获取当前合约余额
        return ERC20Interface(token).balanceOf(address(this));
    }

    /**
     * @notice 获取任意账户的某个代币余额。
     * @param token 目标代币合约地址
     * @param user 要查询余额的用户地址
     * @return uint256 用户地址的代币余额
     */
    function balanceOf(address token, address user) internal view returns (uint256) {
        // 调用 ERC20 的 balanceOf(user) 方法，返回用户余额
        return ERC20Interface(token).balanceOf(user);
    }

    /**
     * @notice 安全地授权某地址可支配指定数量的代币。
     * @dev 使用底层 call 调用 `approve(address,uint256)`，并验证返回值。
     * @param token 目标代币合约地址
     * @param to 被授权地址
     * @param value 授权数量
     *
     * 要求：
     * - 调用必须成功；
     * - 若返回数据不为空，需解码为 true。
     */
    function safeApprove(address token, address to, uint256 value) internal {
        // keccak256("approve(address,uint256)") = 0x095ea7b3
        // 通过底层 call 调用 approve 函数
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));

        // 要求调用成功，并且返回值为空或为 true
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
    }

    /**
     * @notice 安全地向目标地址转账代币。
     * @dev 使用底层 call 调用 `transfer(address,uint256)`，并验证返回值。
     * @param token 目标代币合约地址
     * @param to 接收者地址
     * @param value 转账数量
     *
     * 要求：
     * - 调用必须成功；
     * - 若返回数据不为空，需解码为 true。
     */
    function safeTransfer(address token, address to, uint256 value) internal {
        // keccak256("transfer(address,uint256)") = 0xa9059cbb
        // 通过底层 call 调用 transfer 函数
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));

        // 要求调用成功，并且返回值为空或为 true
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
    }

    /**
     * @notice 安全地从指定账户向目标地址转账代币。
     * @dev 使用底层 call 调用 `transferFrom(address,address,uint256)`，并验证返回值。
     * @param token 目标代币合约地址
     * @param from 代币发送者地址
     * @param to 接收者地址
     * @param value 转账数量
     *
     * 要求：
     * - 调用必须成功；
     * - 若返回数据不为空，需解码为 true。
     */
    function safeTransferFrom(address token, address from, address to, uint256 value) internal {
        // keccak256("transferFrom(address,address,uint256)") = 0x23b872dd
        // 通过底层 call 调用 transferFrom 函数
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));

        // 要求调用成功，并且返回值为空或为 true
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
    }
}