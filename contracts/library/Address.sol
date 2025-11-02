// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

/**
 * @title Address 地址工具库
 * @dev 提供与地址类型相关的通用功能，例如判断是否为合约、发送ETH、执行底层调用等
 */
library Address {

    /**
     * @dev 判断指定地址是否为合约地址
     * @param account 需要检测的目标地址
     * @return bool 如果是合约地址返回 true，否则返回 false
     */
    function isContract(address account) internal view returns (bool) {
        // 声明一个变量用于保存地址代码长度
        uint256 size;

        // 使用内联汇编获取指定地址的代码大小
        assembly { size := extcodesize(account) }

        // 如果代码长度大于 0，则说明是合约地址
        return size > 0;
    }

    /**
     * @dev 向目标地址发送指定数量的 ETH
     * @param recipient 接收 ETH 的地址（必须为 payable 类型）
     * @param amount 发送的 ETH 数量（单位：wei）
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        // 检查当前合约账户余额是否足够支付 amount
        require(address(this).balance >= amount, "Address: insufficient balance");

        // 调用 call 方法发送 ETH，并转发所有 gas
        (bool success, ) = recipient.call{value: amount}("");

        // 如果发送失败则回滚
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev 执行目标合约的底层 call 调用
     * @param target 被调用的合约地址
     * @param data 编码后的调用数据（包含函数选择器与参数）
     * @return bytes 返回合约调用的原始返回数据
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        // 调用重载方法，使用默认错误提示信息
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev 执行目标合约的底层 call 调用（带错误提示信息）
     * @param target 被调用的合约地址
     * @param data 编码后的调用数据
     * @param errorMessage 当调用失败时返回的错误信息
     * @return bytes 返回合约调用的原始返回数据
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        // 使用带 value 的重载函数，但 value=0
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev 执行目标合约的底层 call 调用并附带 ETH 转账
     * @param target 被调用的合约地址
     * @param data 编码后的调用数据
     * @param value 需要一并发送的 ETH 数量（单位：wei）
     * @return bytes 返回合约调用的原始返回数据
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        // 调用带错误信息版本
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev 执行目标合约的底层 call 调用（可附带 ETH 转账与自定义错误信息）
     * @param target 被调用的合约地址
     * @param data 调用数据
     * @param value 附带的 ETH 金额（单位：wei）
     * @param errorMessage 调用失败时的错误提示
     * @return bytes 返回调用的原始返回数据
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        // 检查合约余额是否足够支付转账金额
        require(address(this).balance >= value, "Address: insufficient balance for call");

        // 确认目标地址是一个合约
        require(isContract(target), "Address: call to non-contract");

        // 执行底层 call 调用并附带 ETH
        (bool success, bytes memory returndata) = target.call{value: value}(data);

        // 调用内部函数校验执行结果
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev 执行目标合约的静态调用（staticcall），不会修改链上状态
     * @param target 被调用的合约地址
     * @param data 调用数据
     * @return bytes 返回静态调用的原始返回数据
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        // 调用重载版本，添加默认错误提示
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev 执行目标合约的静态调用（带错误信息）
     * @param target 被调用的合约地址
     * @param data 调用数据
     * @param errorMessage 调用失败时的错误提示
     * @return bytes 返回静态调用的原始返回数据
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        // 检查目标地址是否为合约
        require(isContract(target), "Address: static call to non-contract");

        // 执行底层 staticcall 调用
        (bool success, bytes memory returndata) = target.staticcall(data);

        // 校验执行结果
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev 执行目标合约的 delegatecall 调用（上下文为当前合约）
     * @param target 被调用的合约地址
     * @param data 调用数据
     * @return bytes 返回调用的原始返回数据
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        // 调用带错误提示版本
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev 执行目标合约的 delegatecall 调用（带错误信息）
     * @param target 被调用的合约地址
     * @param data 调用数据
     * @param errorMessage 调用失败时的错误提示
     * @return bytes 返回调用的原始返回数据
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        // 检查目标是否为合约地址
        require(isContract(target), "Address: delegate call to non-contract");

        // 执行底层 delegatecall 调用
        (bool success, bytes memory returndata) = target.delegatecall(data);

        // 校验执行结果
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev 校验底层调用结果，如果失败则回滚并返回错误信息
     * @param success 调用是否成功
     * @param returndata 返回的字节数据
     * @param errorMessage 调用失败时的错误提示
     * @return bytes 返回调用成功时的原始数据
     */
    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
        // 如果执行成功，直接返回返回数据
        if (success) {
            return returndata;
        } else {
            // 如果返回数据中包含错误原因，则直接使用 assembly 复原并回滚
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                // 否则使用自定义错误信息回滚
                revert(errorMessage);
            }
        }
        return bytes("");
    }
}