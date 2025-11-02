// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

/**
 * @title SafeMath
 * @dev Solidity 安全数学运算库，提供带溢出检查的加减乘除与取模操作。
 *
 * 在 Solidity 中，整数运算默认会发生“溢出回绕”现象（即超出范围后自动取模），
 * 这可能导致严重的安全漏洞。本库在检测到溢出或除零时会自动 revert，
 * 从而避免此类错误。
 *
 * 推荐始终使用 SafeMath 以确保算术安全。
 */
library SafeMath {

    /**
     * @notice 返回两个无符号整数相加的结果，若溢出则 revert。
     * @dev 对应 Solidity 的 `+` 运算符。
     * @param a 加数
     * @param b 被加数
     * @return uint256 相加结果
     *
     * 要求：
     * - 不得发生溢出。
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @notice 返回两个无符号整数相减的结果，若结果为负则 revert。
     * @dev 对应 Solidity 的 `-` 运算符。
     * @param a 被减数
     * @param b 减数
     * @return uint256 相减结果
     *
     * 要求：
     * - 不得发生下溢。
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @notice 返回两个无符号整数相减的结果，带自定义错误消息。
     * @dev 对应 Solidity 的 `-` 运算符。
     * @param a 被减数
     * @param b 减数
     * @param errorMessage 自定义错误提示
     * @return uint256 相减结果
     *
     * 要求：
     * - 不得发生下溢。
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    /**
     * @notice 返回两个无符号整数相乘的结果，若溢出则 revert。
     * @dev 对应 Solidity 的 `*` 运算符。
     * @param a 乘数
     * @param b 被乘数
     * @return uint256 相乘结果
     *
     * 要求：
     * - 不得发生溢出。
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas 优化：若 a 为 0，则直接返回 0，可节省 gas。
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @notice 返回两个无符号整数的整数除法结果，向下取整。
     * @dev 对应 Solidity 的 `/` 运算符。
     * @param a 被除数
     * @param b 除数
     * @return uint256 除法结果
     *
     * 要求：
     * - 除数不能为零。
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @notice 返回两个无符号整数的整数除法结果（带自定义错误消息）。
     * @dev 对应 Solidity 的 `/` 运算符。使用 revert（不消耗多余 gas）。
     * @param a 被除数
     * @param b 除数
     * @param errorMessage 自定义错误提示
     * @return uint256 除法结果
     *
     * 要求：
     * - 除数不能为零。
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    /**
     * @notice 返回两个无符号整数相除的余数。
     * @dev 对应 Solidity 的 `%` 运算符。
     * @param a 被除数
     * @param b 除数
     * @return uint256 取模结果
     *
     * 要求：
     * - 除数不能为零。
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @notice 返回两个无符号整数相除的余数（带自定义错误消息）。
     * @dev 对应 Solidity 的 `%` 运算符。
     * @param a 被除数
     * @param b 除数
     * @param errorMessage 自定义错误提示
     * @return uint256 取模结果
     *
     * 要求：
     * - 除数不能为零。
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}