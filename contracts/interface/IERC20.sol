// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

/**
 * @title ERC20 标准代币接口定义
 * @dev 本接口定义了符合 ERC20 标准的基础函数与事件，
 * 用于实现代币的查询、转账、授权、以及动态名称修改等功能。
 */
interface IERC20 {

    /**
     * @notice 获取代币的小数位数
     * @dev 通常用于表示代币的精度，例如 18 表示支持 10^-18 的最小单位
     * @return 代币的小数位数
     */
    function decimals() external view returns (uint8);

    /**
     * @notice 获取代币名称
     * @return 代币的完整名称
     */
    function name() external view returns (string memory);

    /**
     * @notice 获取代币符号
     * @return 代币的简称或标识符
     */
    function symbol() external view returns (string memory);

    /**
     * @notice 获取代币的总发行量
     * @dev 表示当前存在的全部代币数量
     * @return 当前代币总供应量
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice 查询指定账户的代币余额
     * @param account 要查询余额的账户地址
     * @return 该账户持有的代币数量
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @notice 将代币从调用者账户转移给接收者账户
     * @dev 成功后触发 Transfer 事件
     * @param recipient 接收代币的账户地址
     * @param amount 要转移的代币数量
     * @return 操作是否成功
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @notice 查询支出者可代表所有者支配的代币剩余额度
     * @param owner 代币所有者地址
     * @param spender 被授权支出者地址
     * @return 可支配的剩余额度
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @notice 授权指定地址可支配调用者的代币
     * @dev 修改授权额度时，建议先将额度设为 0 再设为新值，以避免交易顺序问题
     * @param spender 被授权支出者地址
     * @param amount 授权的代币数量
     * @return 操作是否成功
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @notice 通过授权额度，将代币从发送者转移至接收者
     * @dev 调用者必须拥有足够的授权额度，成功后触发 Transfer 事件
     * @param sender 代币发送方地址
     * @param recipient 代币接收方地址
     * @param amount 要转移的代币数量
     * @return 操作是否成功
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @notice 修改代币名称与符号
     * @dev 某些特殊代币允许动态修改名称与符号
     * @param _name 新代币名称
     * @param _symbol 新代币符号
     */
    function changeTokenName(string calldata _name, string calldata _symbol) external;

    /**
     * @notice 当代币发生转账时触发
     * @param from 代币发送方地址
     * @param to 代币接收方地址
     * @param value 转账的代币数量
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @notice 当代币授权额度发生变更时触发
     * @param owner 代币所有者地址
     * @param spender 被授权支出者地址
     * @param value 新的授权额度
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}