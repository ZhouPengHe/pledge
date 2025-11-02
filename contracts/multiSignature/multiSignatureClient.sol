// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

/**
 * @title 多签接口定义
 * @dev 该接口用于验证消息哈希是否已通过多签合约的有效签名
 */
interface IMultiSignature {
    /**
     * @notice 验证消息哈希是否被多签合约批准
     * @param msghash 需验证的消息哈希
     * @param lastIndex 上一次签名索引（用于防止重复签名）
     * @return 返回新的索引值，大于 lastIndex 表示验证通过
     */
    function getValidSignature(bytes32 msghash, uint256 lastIndex) external view returns (uint256);
}

/**
 * @title 多签客户端基类
 * @dev 所有需要多签控制的合约可继承该类，通过 `validCall` 修饰器保护关键函数
 */
contract multiSignatureClient {

    // 存储多签合约地址的固定槽位（通过 keccak256 生成唯一位置）
    uint256 private constant multiSignaturePositon = uint256(keccak256("org.multiSignature.storage"));

    // 默认签名索引值，用于初始验证
    uint256 private constant defaultIndex = 0;

    /**
     * @notice 构造函数
     * @dev 部署时传入多签合约地址，并写入固定存储槽位
     * @param multiSignature 多签合约地址
     */
    constructor(address multiSignature) public {
        require(multiSignature != address(0), "multiSignatureClient : Multiple signature contract address is zero!");
        saveValue(multiSignaturePositon, uint256(multiSignature));
    }

    /**
     * @notice 获取当前绑定的多签合约地址
     * @return 返回多签合约地址
     */
    function getMultiSignatureAddress() public view returns (address) {
        return address(getValue(multiSignaturePositon));
    }

    /**
     * @notice 多签校验修饰器
     * @dev 修饰后的函数在执行前会强制进行多签验证
     */
    modifier validCall() {
        checkMultiSignature();
        _;
    }

    /**
     * @notice 多签验证逻辑
     * @dev 通过 msg.sender 和合约地址生成哈希，交由多签合约验证是否已授权
     *      若未通过验证则 revert 交易
     */
    function checkMultiSignature() internal view {
        uint256 value;
        // 获取当前交易的 msg.value（此处保留逻辑，但未使用）
        assembly {
            value := callvalue()
        }

        // 生成消息哈希：由调用者地址 + 当前合约地址组成
        bytes32 msgHash = keccak256(abi.encodePacked(msg.sender, address(this)));

        // 获取当前绑定的多签合约地址
        address multiSign = getMultiSignatureAddress();

        // 调用多签合约验证签名是否有效
        uint256 newIndex = IMultiSignature(multiSign).getValidSignature(msgHash, defaultIndex);

        // 验证失败则回滚交易
        require(newIndex > defaultIndex, "multiSignatureClient : This tx is not aprroved");
    }

    /**
     * @notice 保存 uint256 值到指定存储槽位
     * @dev 使用内联汇编直接操作存储（低级操作，避免冲突）
     * @param position 存储位置
     * @param value 要保存的值
     */
    function saveValue(uint256 position, uint256 value) internal {
        assembly {
            sstore(position, value)
        }
    }

    /**
     * @notice 从指定存储槽位读取 uint256 值
     * @dev 使用内联汇编直接读取存储
     * @param position 存储位置
     * @return value 读取到的值
     */
    function getValue(uint256 position) internal view returns (uint256 value) {
        assembly {
            value := sload(position)
        }
    }
}