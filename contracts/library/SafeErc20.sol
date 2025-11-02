// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./SafeMath.sol";
import "./Address.sol";
import "../interface/IERC20.sol";

/**
 * @title SafeERC20
 * @dev ERC20 安全操作库
 * 该库为 ERC20 的标准操作（transfer、transferFrom、approve 等）提供安全封装。
 * 当代币合约在执行失败时返回 false 或 revert 时，本库会自动处理，避免潜在的错误。
 * 使用方式：
 * 在合约中添加 `using SafeERC20 for IERC20;`
 * 之后可通过 `token.safeTransfer(...)`、`token.safeApprove(...)` 等方法安全调用。
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    /**
     * @notice 安全地向指定地址转账代币
     * @dev 若代币合约返回 false 或 revert，会自动抛出异常。
     * @param token 要转账的 ERC20 代币合约实例
     * @param to 接收方地址
     * @param value 转账的代币数量
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @notice 安全地从指定地址向目标地址转账代币
     * @dev 若代币合约返回 false 或 revert，会自动抛出异常。
     * @param token 要转账的 ERC20 代币合约实例
     * @param from 代币转出方地址
     * @param to 代币接收方地址
     * @param value 转账的代币数量
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @notice 安全设置代币授权额度（不推荐使用）
     * @dev 此函数存在与 IERC20-approve 类似的问题：若当前非 0，再次设置非 0 可能导致竞争风险。
     * 因此推荐使用 {safeIncreaseAllowance} 或 {safeDecreaseAllowance} 替代。
     * @param token ERC20 代币实例
     * @param spender 被授权的地址
     * @param value 授权的代币数量
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // 仅当初次授权（0 -> 非0）或完全重置（非0 -> 0）时可用。
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @notice 安全地增加授权额度
     * @dev 使用 SafeMath 计算新额度，防止溢出。
     * @param token ERC20 代币实例
     * @param spender 被授权的地址
     * @param value 增加的代币数量
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @notice 安全地减少授权额度
     * @dev 若减少后的额度为负，则 revert。
     * @param token ERC20 代币实例
     * @param spender 被授权的地址
     * @param value 减少的代币数量
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev 内部函数：执行低级调用并检查返回结果。
     * 模拟 Solidity 的高层函数调用行为，但允许目标函数不返回值。
     * 如果返回值存在，必须为 true，否则抛出异常。
     * @param token 要调用的 ERC20 代币合约实例
     * @param data ABI 编码后的函数调用数据（例如 transfer 的 selector 与参数）
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // 使用 Address 库的 functionCall，确保目标地址为合约且调用成功。
        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");

        // 若返回数据不为空，则解析为 bool 并检查结果。
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}