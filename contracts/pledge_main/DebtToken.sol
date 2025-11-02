// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

// 引入 OpenZeppelin 的 ERC20 合约，用于提供标准代币功能
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 引入 AddressPrivileges 合约，用于实现铸币权限控制
import "./AddressPrivileges.sol";


// DebtToken 合约
// 用于发行债务代币，继承 ERC20 标准代币逻辑与自定义的 AddressPrivileges 权限控制逻辑
contract DebtToken is ERC20, AddressPrivileges {

    // 构造函数
    // @param _name 代币名称
    // @param _symbol 代币符号
    // @param multiSignature 多签合约地址（用于权限控制）
    constructor(string memory _name, string memory _symbol, address multiSignature)
    public
    ERC20(_name, _symbol)                // 调用 ERC20 构造函数，初始化代币名称与符号
    AddressPrivileges(multiSignature)    // 调用 AddressPrivileges 构造函数，初始化多签权限
    {
        // 构造函数体为空，仅用于初始化继承的父类
    }

    /**
     * @dev 铸造代币（仅限具有铸币权限的账户调用）
     * @param _to 接收代币的地址
     * @param _amount 铸造数量
     * @return 是否成功（true 表示成功）
     */
    function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
        // 调用 ERC20 内置的 _mint 函数，向指定地址铸造代币
        _mint(_to, _amount);
        // 返回执行成功
        return true;
    }

    /**
     * @dev 销毁代币（仅限具有铸币权限的账户调用）
     * @param _from 销毁代币的地址
     * @param _amount 销毁数量
     * @return 是否成功（true 表示成功）
     */
    function burn(address _from, uint256 _amount) public onlyMinter returns (bool) {
        // 调用 ERC20 内置的 _burn 函数，从指定地址销毁代币
        _burn(_from, _amount);
        // 返回执行成功
        return true;
    }
}