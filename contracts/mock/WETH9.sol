// SPDX-License-Identifier: MIT
pragma solidity ^0.4.18;

// 定义 Wrapped Ether (WETH) 合约，用于将原生 ETH 封装为 ERC20 代币
contract WETH9 {
    // 代币名称
    string public name = "Wrapped Ether";
    // 代币符号
    string public symbol = "WETH";
    // 小数位精度
    uint8  public decimals = 18;
    // 授权事件，当某地址授权他人可操作其代币时触发
    event Approval(address indexed src, address indexed guy, uint wad);
    // 转账事件，当代币从一个地址转到另一个地址时触发
    event Transfer(address indexed src, address indexed dst, uint wad);
    // 存入事件，当用户将 ETH 存入合约并获得 WETH 时触发
    event Deposit(address indexed dst, uint wad);
    // 提取事件，当用户将 WETH 兑换回 ETH 时触发
    event Withdrawal(address indexed src, uint wad);

    // 每个地址对应的 WETH 余额映射
    mapping (address => uint) public balanceOf;
    // 授权额度映射，记录某地址授权另一地址可支配的 WETH 数量
    mapping (address => mapping (address => uint)) public allowance;

    /**
     * @dev 回退函数，允许用户直接向合约发送 ETH 时自动调用 deposit()
     */
    function() public payable {
        // 调用存入函数，将 ETH 转换为 WETH
        deposit();
    }

    /**
     * @dev 存入 ETH 并获得等值 WETH
     * @notice 用户调用该函数并附带 ETH，获得相应数量的 WETH
     */
    function deposit() public payable {
        // 将发送的 ETH 金额累加到调用者的 WETH 余额中
        balanceOf[msg.sender] += msg.value;
        // 触发存入事件，记录存入数量
        Deposit(msg.sender, msg.value);
    }

    /**
     * @dev 提取 ETH，将持有的 WETH 兑换为原生 ETH
     * @param wad 要兑换的 WETH 数量
     */
    function withdraw(uint wad) public {
        // 确认用户的余额足够兑换
        require(balanceOf[msg.sender] >= wad);
        // 扣除相应的 WETH 数量
        balanceOf[msg.sender] -= wad;
        // 将等值的 ETH 转回给用户
        msg.sender.transfer(wad);
        // 触发提取事件
        Withdrawal(msg.sender, wad);
    }

    /**
     * @dev 获取当前合约的总 WETH 供应量
     * @return uint 返回合约中持有的 ETH 总量
     */
    function totalSupply() public view returns (uint) {
        // 返回合约当前余额（即所有用户存入的 ETH 总额）
        return this.balance;
    }

    /**
     * @dev 授权他人可支配自己指定数量的 WETH
     * @param guy 被授权的地址
     * @param wad 授权的数量
     * @return bool 返回授权是否成功
     */
    function approve(address guy, uint wad) public returns (bool) {
        // 设置授权额度
        allowance[msg.sender][guy] = wad;
        // 触发授权事件
        Approval(msg.sender, guy, wad);
        return true;
    }

    /**
     * @dev 转账函数，将调用者的 WETH 转给目标地址
     * @param dst 接收者地址
     * @param wad 转账数量
     * @return bool 返回转账是否成功
     */
    function transfer(address dst, uint wad) public returns (bool) {
        // 调用 transferFrom 实现转账逻辑
        return transferFrom(msg.sender, dst, wad);
    }

    /**
     * @dev 从指定地址向目标地址转移 WETH，支持授权转账
     * @param src 发送方地址
     * @param dst 接收方地址
     * @param wad 转账数量
     * @return bool 返回转账是否成功
     */
    function transferFrom(address src, address dst, uint wad) public returns (bool) {
        // 检查发送方余额是否足够
        require(balanceOf[src] >= wad);

        // 如果不是自己操作且授权额度有限，则减少授权额度
        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
            // 检查授权额度是否足够
            require(allowance[src][msg.sender] >= wad);
            // 扣减授权额度
            allowance[src][msg.sender] -= wad;
        }
        // 从发送方余额扣除
        balanceOf[src] -= wad;
        // 增加接收方余额
        balanceOf[dst] += wad;
        // 触发转账事件
        Transfer(src, dst, wad);
        return true;
    }
}