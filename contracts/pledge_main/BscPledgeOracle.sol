// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

// 引入多签客户端合约，用于执行多重签名验证
import "../multiSignature/multiSignatureClient.sol";
// 引入 Chainlink 的价格预言机接口，用于获取链上价格数据
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

// BscPledgeOracle 合约
// 用于管理资产价格数据，包括手动设置价格和通过 Chainlink 预言机获取价格
// 支持多签机制，只有多签批准的调用才可修改数据
contract BscPledgeOracle is multiSignatureClient {

    // 存储每个资产对应的 Chainlink 预言机合约接口
    mapping(uint256 => AggregatorV3Interface) internal assetsMap;

    // 存储每个资产对应的小数位数，用于价格精度换算
    mapping(uint256 => uint256) internal decimalsMap;

    // 存储每个资产的价格（用于本地设置价格时）
    mapping(uint256 => uint256) internal priceMap;

    // 全局精度因子，默认值为 1
    uint256 internal decimals = 1;

    // 构造函数
    // @param multiSignature 多签合约地址
    constructor(address multiSignature) multiSignatureClient(multiSignature) public {
        // 调用父类构造函数初始化多签逻辑
        // （示例中注释掉的部分是预定义资产与 Chainlink 预言机的绑定）
    }


    /**
     * @dev 设置全局精度参数
     * @param newDecimals 新的精度值
     */
    function setDecimals(uint256 newDecimals) public validCall {
        // 更新全局价格精度因子
        decimals = newDecimals;
    }


    /**
     * @dev 批量设置多个资产的价格
     * @param assets 资产地址数组（以 uint256 形式传入）
     * @param prices 对应的资产价格数组
     */
    function setPrices(uint256[] memory assets, uint256[] memory prices) external validCall {
        // 确认资产数组与价格数组长度相同
        require(assets.length == prices.length, "input arrays' length are not equal");

        // 计算数组长度
        uint256 len = assets.length;

        // 循环设置每个资产的价格
        for (uint i = 0; i < len; i++) {
            priceMap[i] = prices[i];
        }
    }


    /**
     * @dev 批量获取多个资产的价格
     * @param assets 资产地址数组（以 uint256 形式传入）
     * @return prices 对应的资产价格数组
     */
    function getPrices(uint256[] memory assets) public view returns (uint256[] memory) {
        // 获取输入数组长度
        uint256 len = assets.length;

        // 创建一个新的同长度数组用于存放返回结果
        uint256[] memory prices = new uint256[](len);

        // 循环调用 getUnderlyingPrice 获取价格
        for (uint i = 0; i < len; i++) {
            prices[i] = getUnderlyingPrice(assets[i]);
        }

        // 返回所有资产价格数组
        return prices;
    }


    /**
     * @dev 获取单个资产价格
     * @param asset 资产地址
     * @return 资产价格（按 1e8 缩放）
     */
    function getPrice(address asset) public view returns (uint256) {
        // 将地址转换为 uint256 后调用底层价格函数
        return getUnderlyingPrice(uint256(asset));
    }


    /**
     * @dev 根据资产索引获取对应价格
     * @param underlying 资产索引或地址（uint256 类型）
     * @return 资产价格（按 1e8 缩放）
     */
    function getUnderlyingPrice(uint256 underlying) public view returns (uint256) {
        // 从映射中获取该资产绑定的预言机接口
        AggregatorV3Interface assetsPrice = assetsMap[underlying];

        // 如果资产绑定了 Chainlink 预言机
        if (address(assetsPrice) != address(0)) {
            // 获取 Chainlink 最新价格数据
            (, int price,,,) = assetsPrice.latestRoundData();

            // 获取该资产的小数位精度
            uint256 tokenDecimals = decimalsMap[underlying];

            // 如果资产精度小于 18，则放大价格
            if (tokenDecimals < 18) {
                return uint256(price) / decimals * (10 ** (18 - tokenDecimals));

                // 如果资产精度大于 18，则缩小价格
            } else if (tokenDecimals > 18) {
                return uint256(price) / decimals / (10 ** (18 - tokenDecimals));

                // 如果资产精度等于 18，直接按当前精度返回
            } else {
                return uint256(price) / decimals;
            }

            // 若资产未绑定预言机，则返回手动设置的价格
        } else {
            return priceMap[underlying];
        }
    }


    /**
     * @dev 手动设置某个资产价格
     * @param asset 资产地址
     * @param price 新的价格数值
     */
    function setPrice(address asset, uint256 price) public validCall {
        // 将资产地址转换为 uint256 并存入映射
        priceMap[uint256(asset)] = price;
    }


    /**
     * @dev 手动设置底层资产价格
     * @param underlying 资产索引（或转换后的地址）
     * @param price 新的价格
     */
    function setUnderlyingPrice(uint256 underlying, uint256 price) public validCall {
        // 检查资产索引合法性
        require(underlying > 0, "underlying cannot be zero");

        // 更新价格映射
        priceMap[underlying] = price;
    }


    /**
     * @dev 设置资产的 Chainlink 预言机地址与精度
     * @param asset 资产地址
     * @param aggergator Chainlink 预言机合约地址
     * @param _decimals 资产价格精度
     */
    function setAssetsAggregator(address asset, address aggergator, uint256 _decimals) public validCall {
        // 建立资产与预言机的映射关系
        assetsMap[uint256(asset)] = AggregatorV3Interface(aggergator);

        // 记录该资产对应的精度
        decimalsMap[uint256(asset)] = _decimals;
    }


    /**
     * @dev 设置底层资产的 Chainlink 预言机与精度
     * @param underlying 资产索引
     * @param aggergator Chainlink 预言机合约地址
     * @param _decimals 精度
     */
    function setUnderlyingAggregator(uint256 underlying, address aggergator, uint256 _decimals) public validCall {
        // 检查索引有效性
        require(underlying > 0, "underlying cannot be zero");

        // 更新底层资产对应的预言机与精度
        assetsMap[underlying] = AggregatorV3Interface(aggergator);
        decimalsMap[underlying] = _decimals;
    }


    /**
     * @dev 获取指定资产对应的预言机与精度信息
     * @param asset 资产地址
     * @return aggregatorAddress 预言机地址
     * @return decimalsValue 该资产的小数位精度
     */
    function getAssetsAggregator(address asset) public view returns (address, uint256) {
        // 返回资产绑定的预言机地址与精度
        return (address(assetsMap[uint256(asset)]), decimalsMap[uint256(asset)]);
    }


    /**
     * @dev 根据索引获取底层资产的预言机与精度信息
     * @param underlying 资产索引
     * @return aggregatorAddress 预言机地址
     * @return decimalsValue 该资产的小数位精度
     */
    function getUnderlyingAggregator(uint256 underlying) public view returns (address, uint256) {
        // 返回底层资产的预言机地址与精度
        return (address(assetsMap[underlying]), decimalsMap[underlying]);
    }
}