// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

/**
 * @title IUniswapV2Router02 接口
 * @dev 定义 Uniswap V2 Router 的核心功能，包括添加/移除流动性、代币兑换、
 * 支持手续费代币的版本等。
 */
interface IUniswapV2Router02 {
    /**
     * @dev 返回工厂合约地址。
     * @return 工厂合约的地址
     */
    function factory() external pure returns (address);

    /**
     * @dev 返回 WETH 合约地址。
     * @return WETH 合约的地址
     */
    function WETH() external pure returns (address);

    /**
     * @dev 添加代币对流动性。
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @param amountADesired 希望提供的代币A数量
     * @param amountBDesired 希望提供的代币B数量
     * @param amountAMin 最小可接受代币A数量
     * @param amountBMin 最小可接受代币B数量
     * @param to 接收 LP 代币的地址
     * @param deadline 截止时间戳
     * @return amountA 实际使用的代币A数量
     * @return amountB 实际使用的代币B数量
     * @return liquidity 获得的流动性代币数量
     */
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    /**
     * @dev 使用 ETH 添加流动性。
     * @param token ERC20 代币地址
     * @param amountTokenDesired 希望提供的代币数量
     * @param amountTokenMin 最小可接受代币数量
     * @param amountETHMin 最小可接受 ETH 数量
     * @param to 接收 LP 代币的地址
     * @param deadline 截止时间戳
     * @return amountToken 实际使用的代币数量
     * @return amountETH 实际使用的 ETH 数量
     * @return liquidity 获得的流动性代币数量
     */
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    /**
     * @dev 移除代币对流动性。
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @param liquidity LP 代币数量
     * @param amountAMin 最小代币A数量
     * @param amountBMin 最小代币B数量
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amountA 实际返回的代币A数量
     * @return amountB 实际返回的代币B数量
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    /**
     * @dev 移除代币-ETH 流动性。
     * @param token ERC20 代币地址
     * @param liquidity LP 代币数量
     * @param amountTokenMin 最小代币数量
     * @param amountETHMin 最小 ETH 数量
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amountToken 实际返回的代币数量
     * @return amountETH 实际返回的 ETH 数量
     */
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    /**
     * @dev 使用 permit 授权方式移除流动性。
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @param liquidity LP 代币数量
     * @param amountAMin 最小代币A数量
     * @param amountBMin 最小代币B数量
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @param approveMax 是否使用最大授权额度
     * @param v 签名参数 v
     * @param r 签名参数 r
     * @param s 签名参数 s
     * @return amountA 实际返回的代币A数量
     * @return amountB 实际返回的代币B数量
     */
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    /**
     * @dev 使用 permit 授权方式移除代币-ETH 流动性。
     * @param token ERC20 代币地址
     * @param liquidity LP 代币数量
     * @param amountTokenMin 最小代币数量
     * @param amountETHMin 最小 ETH 数量
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @param approveMax 是否使用最大授权额度
     * @param v 签名参数 v
     * @param r 签名参数 r
     * @param s 签名参数 s
     * @return amountToken 实际返回的代币数量
     * @return amountETH 实际返回的 ETH 数量
     */
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    /**
     * @dev 代币兑换：固定输入，获取最小输出。
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amounts 各阶段代币数量数组
     */
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 代币兑换：固定输出，推算最大输入。
     * @param amountOut 目标输出数量
     * @param amountInMax 最大允许输入数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amounts 各阶段代币数量数组
     */
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 使用 ETH 兑换代币。
     * @param amountOutMin 最小输出数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amounts 各阶段代币数量数组
     */
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    /**
     * @dev 固定输出代币数量，推算需要的最大 ETH 数量。
     * @param amountOut 目标输出数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amounts 各阶段代币数量数组
     */
    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    /**
     * @dev 固定输入代币数量，兑换 ETH。
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出 ETH 数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amounts 各阶段代币数量数组
     */
    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 固定输出 ETH 数量，推算最大输入代币数量。
     * @param amountOut 目标 ETH 数量
     * @param amountInMax 最大输入代币数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amounts 各阶段代币数量数组
     */
    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 报价函数。
     * @param amountA 输入数量
     * @param reserveA 储备A
     * @param reserveB 储备B
     * @return amountB 可获得的数量
     */
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    /**
     * @dev 计算输入兑换输出。
     * @param amountIn 输入代币数量
     * @param reserveIn 输入代币储备
     * @param reserveOut 输出代币储备
     * @return amountOut 输出代币数量
     */
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    /**
     * @dev 计算输出所需输入。
     * @param amountOut 目标输出代币数量
     * @param reserveIn 输入代币储备
     * @param reserveOut 输出代币储备
     * @return amountIn 所需输入代币数量
     */
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    /**
     * @dev 获取路径兑换的输出数组。
     * @param amountIn 输入代币数量
     * @param path 兑换路径
     * @return amounts 各阶段代币数量数组
     */
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    /**
     * @dev 获取路径兑换所需的输入数组。
     * @param amountOut 目标输出代币数量
     * @param path 兑换路径
     * @return amounts 各阶段代币数量数组
     */
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

    /**
     * @dev 移除流动性（支持带手续费代币）。
     * @param token ERC20 代币地址
     * @param liquidity LP 代币数量
     * @param amountTokenMin 最小代币数量
     * @param amountETHMin 最小 ETH 数量
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @return amountETH 实际返回的 ETH 数量
     */
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    /**
     * @dev 使用 permit 授权移除流动性（支持带手续费代币）。
     * @param token ERC20 代币地址
     * @param liquidity LP 代币数量
     * @param amountTokenMin 最小代币数量
     * @param amountETHMin 最小 ETH 数量
     * @param to 接收方地址
     * @param deadline 截止时间戳
     * @param approveMax 是否使用最大授权额度
     * @param v 签名参数 v
     * @param r 签名参数 r
     * @param s 签名参数 s
     * @return amountETH 实际返回的 ETH 数量
     */
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    /**
     * @dev 代币兑换（支持带手续费代币）。
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     */
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    /**
     * @dev ETH 兑换代币（支持带手续费代币）。
     * @param amountOutMin 最小输出数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     */
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    /**
     * @dev 代币兑换 ETH（支持带手续费代币）。
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出 ETH 数量
     * @param path 兑换路径
     * @param to 接收方地址
     * @param deadline 截止时间戳
     */
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}