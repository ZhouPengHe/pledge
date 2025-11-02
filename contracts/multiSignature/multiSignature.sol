// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

// 引入多签客户端基础类（用于签名验证、地址存储等）
import "./multiSignatureClient.sol";

/**
 * @title whiteListAddress 库
 * @dev 该库用于管理地址白名单的增删查操作，提供基础工具函数。
 */
library whiteListAddress {
    /**
     * @dev 添加白名单地址
     * @param whiteList 地址数组（存储白名单）
     * @param temp 待添加的地址
     */
    function addWhiteListAddress(address[] storage whiteList, address temp) internal {
        // 如果该地址不在白名单中，则添加
        if (!isEligibleAddress(whiteList, temp)) {
            whiteList.push(temp);
        }
    }

    /**
     * @dev 从白名单中移除地址
     * @param whiteList 地址数组
     * @param temp 待删除的地址
     * @return 是否删除成功
     */
    function removeWhiteListAddress(address[] storage whiteList, address temp) internal returns (bool) {
        // 获取白名单长度
        uint256 len = whiteList.length;
        // 定义索引变量 i
        uint256 i = 0;
        // 遍历白名单，找到待删除的地址
        for (; i < len; i++) {
            if (whiteList[i] == temp) break;
        }
        // 如果找到了目标地址
        if (i < len) {
            // 若删除的不是最后一个元素，则将最后一个元素移动到当前位置
            if (i != len - 1) {
                whiteList[i] = whiteList[len - 1];
            }
            // 删除最后一个元素（数组长度减 1）
            whiteList.pop();
            return true;
        }
        // 没找到则返回 false
        return false;
    }

    /**
     * @dev 判断某个地址是否在白名单中
     * @param whiteList 地址数组
     * @param temp 待检查的地址
     * @return 是否存在
     */
    function isEligibleAddress(address[] memory whiteList, address temp) internal pure returns (bool) {
        // 获取数组长度
        uint256 len = whiteList.length;
        // 遍历白名单
        for (uint256 i = 0; i < len; i++) {
            if (whiteList[i] == temp)
                return true;
        }
        // 未找到，返回 false
        return false;
    }
}

/**
 * @title multiSignature 多重签名合约
 * @dev 实现基于白名单的多签机制：多个授权人签署后才能批准某操作。
 */
contract multiSignature is multiSignatureClient {
    // 默认签名索引（初始值为 0）
    uint256 private constant defaultIndex = 0;

    // 使用 whiteListAddress 库扩展 address[] 类型的方法
    using whiteListAddress for address[];

    // 签名拥有者列表（多签授权人地址）
    address[] public signatureOwners;

    // 通过签名所需的最少签名数（签名门槛）
    uint256 public threshold;

    /**
     * @dev 签名信息结构体
     * @param applicant 发起人地址
     * @param signatures 已签名的授权人列表
     */
    struct signatureInfo {
        address applicant;
        address[] signatures;
    }

    // 记录每个操作（由 msgHash 标识）对应的多签请求列表
    mapping(bytes32 => signatureInfo[]) public signatureMap;

    // 事件：所有权转移
    event TransferOwner(address indexed sender, address indexed oldOwner, address indexed newOwner);

    // 事件：创建签名申请
    event CreateApplication(address indexed from, address indexed to, bytes32 indexed msgHash);

    // 事件：签署申请
    event SignApplication(address indexed from, bytes32 indexed msgHash, uint256 index);

    // 事件：撤销签署
    event RevokeApplication(address indexed from, bytes32 indexed msgHash, uint256 index);

    /**
     * @dev 构造函数，初始化多签系统
     * @param owners 多签所有者地址数组
     * @param limitedSignNum 签名门槛（需多少人签名才通过）
     */
    constructor(address[] memory owners, uint256 limitedSignNum) multiSignatureClient(address(this)) public {
        // 确保门槛值不超过拥有者数量
        require(owners.length >= limitedSignNum, "Multiple Signature : Signature threshold is greater than owners' length!");

        // 初始化所有者与签名门槛
        signatureOwners = owners;
        threshold = limitedSignNum;
    }

    /**
     * @dev 转移某个签名拥有者的地址
     * @param index 要修改的拥有者索引
     * @param newOwner 新的拥有者地址
     */
    function transferOwner(uint256 index, address newOwner) public onlyOwner validCall {
        // 校验索引是否合法
        require(index < signatureOwners.length, "Multiple Signature : Owner index is overflow!");

        // 触发事件，记录所有权变更
        emit TransferOwner(msg.sender, signatureOwners[index], newOwner);

        // 修改拥有者地址
        signatureOwners[index] = newOwner;
    }

    /**
     * @dev 创建一个新的签名申请
     * @param to 被操作的目标地址（例如待执行的合约或账户）
     * @return index 当前申请的索引位置
     */
    function createApplication(address to) external returns (uint256) {
        // 根据发起者和目标地址生成唯一哈希
        bytes32 msghash = getApplicationHash(msg.sender, to);

        // 获取当前该哈希下申请的数量（即新的 index）
        uint256 index = signatureMap[msghash].length;

        // 创建新的签名信息结构体，初始化签名数组为空
        signatureMap[msghash].push(signatureInfo(msg.sender,new address[](0)));

        // 触发创建事件
        emit CreateApplication(msg.sender, to, msghash);

        // 返回该申请在数组中的索引
        return index;
    }

    /**
     * @dev 对某个申请进行签名（批准操作）
     * @param msghash 申请对应的哈希值
     */
    function signApplication(bytes32 msghash) external onlyOwner validIndex(msghash, defaultIndex) {
        // 触发签名事件
        emit SignApplication(msg.sender, msghash, defaultIndex);

        // 将当前调用者添加到签名列表中（若不存在）
        signatureMap[msghash][defaultIndex].signatures.addWhiteListAddress(msg.sender);
    }

    /**
     * @dev 撤销对某个申请的签名
     * @param msghash 申请哈希
     */
    function revokeSignApplication(bytes32 msghash) external onlyOwner validIndex(msghash, defaultIndex) {
        // 触发撤销事件
        emit RevokeApplication(msg.sender, msghash, defaultIndex);

        // 从签名列表中移除当前调用者
        signatureMap[msghash][defaultIndex].signatures.removeWhiteListAddress(msg.sender);
    }

    /**
     * @dev 获取签名是否达到有效门槛
     * @param msghash 申请哈希
     * @param lastIndex 上一次签名检查的索引
     * @return 返回新的索引（若签名数达到门槛，则返回 i+1，否则返回 0）
     */
    function getValidSignature(bytes32 msghash, uint256 lastIndex) external view returns (uint256) {
        // 获取该哈希对应的申请数组
        signatureInfo[] storage info = signatureMap[msghash];

        // 从指定索引开始遍历
        for (uint256 i = lastIndex; i < info.length; i++) {
            // 若当前申请的签名数 ≥ 门槛，说明通过
            if (info[i].signatures.length >= threshold) {
                // 返回下一个索引（表示通过）
                return i + 1;
            }
        }

        // 若未通过则返回 0
        return 0;
    }

    /**
     * @dev 获取指定申请的详细信息
     * @param msghash 申请哈希
     * @param index 申请索引
     * @return applicant 发起人地址
     * @return signatures 当前签名者地址数组
     */
    function getApplicationInfo(bytes32 msghash, uint256 index) validIndex(msghash, index) public view returns (address, address[] memory) {
        // 从映射中取出该申请的结构体
        signatureInfo memory info = signatureMap[msghash][index];

        // 返回申请人及签名列表
        return (info.applicant, info.signatures);
    }

    /**
     * @dev 获取某个哈希下申请的数量
     * @param msghash 申请哈希
     * @return 数量
     */
    function getApplicationCount(bytes32 msghash) public view returns (uint256) {
        return signatureMap[msghash].length;
    }

    /**
     * @dev 生成申请哈希，用于唯一标识某个多签申请
     * @param from 发起地址
     * @param to 目标地址
     * @return bytes32 哈希值
     */
    function getApplicationHash(address from, address to) public pure returns (bytes32) {
        // 对 from + to 拼接后取 keccak256 哈希，作为唯一标识
        return keccak256(abi.encodePacked(from, to));
    }

    /**
     * @dev 访问控制修饰符：仅允许多签拥有者调用
     */
    modifier onlyOwner {
        // 判断当前调用者是否在拥有者列表中
        require(signatureOwners.isEligibleAddress(msg.sender), "Multiple Signature : caller is not in the ownerList!");
        _;
    }

    /**
     * @dev 校验申请索引是否合法的修饰符
     * @param msghash 申请哈希
     * @param index 待校验索引
     */
    modifier validIndex(bytes32 msghash, uint256 index) {
        // 检查索引是否越界
        require(index < signatureMap[msghash].length, "Multiple Signature : Message index is overflow!");
        _;
    }
}