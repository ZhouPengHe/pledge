// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "../multiSignature/multiSignatureClient.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";

// AddressPrivileges 合约
// 主要用于管理具有铸币权限(minter)的地址集合
// 继承自 multiSignatureClient，实现多签权限控制
contract AddressPrivileges is multiSignatureClient {

    // 构造函数
    // @param multiSignature 多签合约地址
    constructor(address multiSignature) multiSignatureClient(multiSignature) public {
        // 调用父类构造函数初始化多签客户端
    }
    // 使用 EnumerableSet 库为 AddressSet 类型提供集合操作方法
    using EnumerableSet for EnumerableSet.AddressSet;
    // 定义一个私有的地址集合，用于存储所有具有铸币权限的地址
    EnumerableSet.AddressSet private _minters;

    /**
     * @dev 添加一个新的铸币权限地址
     * @param _addMinter 要添加的铸币地址
     * @return 是否添加成功（true/false）
     */
    function addMinter(address _addMinter) public validCall returns (bool) {
        // 检查地址不能为零地址
        require(_addMinter != address(0), "Token: _addMinter is the zero address");
        // 将地址加入 _minters 集合中，返回操作结果（true 表示新增成功）
        return EnumerableSet.add(_minters, _addMinter);
    }

    /**
     * @dev 删除一个已有的铸币权限地址
     * @param _delMinter 要删除的铸币地址
     * @return 是否删除成功（true/false）
     */
    function delMinter(address _delMinter) public validCall returns (bool) {
        // 检查地址不能为零地址
        require(_delMinter != address(0), "Token: _delMinter is the zero address");
        // 从 _minters 集合中移除指定地址，返回操作结果
        return EnumerableSet.remove(_minters, _delMinter);
    }

    /**
     * @dev 获取铸币权限地址列表的长度
     * @return 当前铸币地址数量
     */
    function getMinterLength() public view returns (uint256) {
        // 返回 _minters 集合中的地址数量
        return EnumerableSet.length(_minters);
    }

    /**
     * @dev 判断某个地址是否具有铸币权限
     * @param account 待判断的账户地址
     * @return 是否为铸币地址（true/false）
     */
    function isMinter(address account) public view returns (bool) {
        // 判断 account 是否存在于 _minters 集合中
        return EnumerableSet.contains(_minters, account);
    }

    /**
     * @dev 根据索引获取对应的铸币权限地址
     * @param _index 索引位置，从 0 开始
     * @return 对应索引的铸币权限地址
     */
    function getMinter(uint256 _index) public view returns (address) {
        // 检查索引是否超出范围
        require(_index <= getMinterLength() - 1, "Token: index out of bounds");
        // 从集合中按索引获取指定地址
        return EnumerableSet.at(_minters, _index);
    }

    // onlyMinter 修饰符
    // 仅允许具有铸币权限的地址调用被修饰的函数
    modifier onlyMinter() {
        // 检查当前调用者是否为铸币权限地址
        require(isMinter(msg.sender), "Token: caller is not the minter");
        // 继续执行目标函数
        _;
    }
}