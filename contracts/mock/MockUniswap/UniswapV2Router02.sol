/**
 *Submitted for verification at Etherscan.io on 2020-06-05
*/
// import "hardhat/console.sol";
// SPDX-License-Identifier: MIT
pragma solidity =0.6.6;

/**
 * @title IUniswapV2Factory
 * @notice Uniswap V2 工厂合约接口
 */
interface IUniswapV2Factory {
    /**
     * @dev 返回 pair 合约的初始化代码 hash
     * @return bytes32 initCodeHash 初始化代码 hash
     */
    function initCodeHash() external pure returns (bytes32);

    /**
     * @dev 当创建新的交易对时触发事件
     * @param token0 交易对中的第一个代币地址
     * @param token1 交易对中的第二个代币地址
     * @param pair 创建的交易对合约地址
     * @param uint 创建交易对的顺序编号
     */
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    /**
     * @dev 返回手续费接收地址
     * @return address 手续费接收地址
     */
    function feeTo() external view returns (address);

    /**
     * @dev 返回设置手续费地址的权限账户
     * @return address 权限账户地址
     */
    function feeToSetter() external view returns (address);

    /**
     * @dev 获取某一交易对地址
     * @param tokenA 第一个代币地址
     * @param tokenB 第二个代币地址
     * @return pair 返回交易对合约地址
     */
    function getPair(address tokenA, address tokenB) external view returns (address pair);

    /**
     * @dev 根据索引获取所有交易对中的某个交易对地址
     * @param uint 索引值
     * @return pair 返回交易对合约地址
     */
    function allPairs(uint) external view returns (address pair);

    /**
     * @dev 返回所有交易对数量
     * @return uint 交易对总数量
     */
    function allPairsLength() external view returns (uint);

    /**
     * @dev 创建新的交易对
     * @param tokenA 第一个代币地址
     * @param tokenB 第二个代币地址
     * @return pair 返回创建的交易对合约地址
     */
    function createPair(address tokenA, address tokenB) external returns (address pair);

    /**
     * @dev 设置手续费接收地址
     * @param _feeTo 手续费接收地址
     */
    function setFeeTo(address _feeTo) external;

    /**
     * @dev 设置手续费权限账户
     * @param _feeToSetter 权限账户地址
     */
    function setFeeToSetter(address _feeToSetter) external;
}

/**
 * @title IUniswapV2Pair
 * @notice Uniswap V2 交易对合约接口
 */
interface IUniswapV2Pair {
    /**
     * @dev 当授权操作发生时触发事件
     * @param owner 代币拥有者地址
     * @param spender 授权 spender 地址
     * @param value 授权数量
     */
    event Approval(address indexed owner, address indexed spender, uint value);

    /**
     * @dev 当代币转账发生时触发事件
     * @param from 转出地址
     * @param to 转入地址
     * @param value 转账数量
     */
    event Transfer(address indexed from, address indexed to, uint value);

    /**
     * @dev 返回代币名称
     * @return string memory 代币名称
     */
    function name() external pure returns (string memory);

    /**
     * @dev 返回代币符号
     * @return string memory 代币符号
     */
    function symbol() external pure returns (string memory);

    /**
     * @dev 返回代币精度
     * @return uint8 代币小数位
     */
    function decimals() external pure returns (uint8);

    /**
     * @dev 返回代币总供应量
     * @return uint 总供应量
     */
    function totalSupply() external view returns (uint);

    /**
     * @dev 查询账户余额
     * @param owner 账户地址
     * @return uint 余额
     */
    function balanceOf(address owner) external view returns (uint);

    /**
     * @dev 查询授权额度
     * @param owner 拥有者地址
     * @param spender 授权 spender 地址
     * @return uint 授权额度
     */
    function allowance(address owner, address spender) external view returns (uint);

    /**
     * @dev 授权 spender 消耗代币
     * @param spender 授权地址
     * @param value 授权数量
     * @return bool 是否成功
     */
    function approve(address spender, uint value) external returns (bool);

    /**
     * @dev 转账代币
     * @param to 接收地址
     * @param value 转账数量
     * @return bool 是否成功
     */
    function transfer(address to, uint value) external returns (bool);

    /**
     * @dev 从指定地址转账
     * @param from 转出地址
     * @param to 接收地址
     * @param value 转账数量
     * @return bool 是否成功
     */
    function transferFrom(address from, address to, uint value) external returns (bool);

    /**
     * @dev 返回 EIP-712 DOMAIN_SEPARATOR
     * @return bytes32 domain separator
     */
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /**
     * @dev 返回 permit 类型 hash
     * @return bytes32 permit typehash
     */
    function PERMIT_TYPEHASH() external pure returns (bytes32);

    /**
     * @dev 查询账户签名 nonce
     * @param owner 查询的账户地址
     * @return uint nonce 值
     */
    function nonces(address owner) external view returns (uint);

    /**
     * @dev 使用 EIP-2612 permit 授权
     * @param owner 代币拥有者地址
     * @param spender 授权 spender 地址
     * @param value 授权数量
     * @param deadline 授权过期时间
     * @param v 签名参数 v
     * @param r 签名参数 r
     * @param s 签名参数 s
     */
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    /**
     * @dev 铸币事件
     * @param sender 铸币发起地址
     * @param amount0 铸入 token0 数量
     * @param amount1 铸入 token1 数量
     */
    event Mint(address indexed sender, uint amount0, uint amount1);

    /**
     * @dev 销毁事件
     * @param sender 销毁发起地址
     * @param amount0 销毁 token0 数量
     * @param amount1 销毁 token1 数量
     * @param to 接收地址
     */
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    /**
     * @dev 交易事件
     * @param sender 发起交易地址
     * @param amount0In token0 输入量
     * @param amount1In token1 输入量
     * @param amount0Out token0 输出量
     * @param amount1Out token1 输出量
     * @param to 接收地址
     */
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );

    /**
     * @dev 储备更新事件
     * @param reserve0 token0 储备量
     * @param reserve1 token1 储备量
     */
    event Sync(uint112 reserve0, uint112 reserve1);

    /**
     * @dev 返回最小流动性数量
     * @return uint 最小流动性
     */
    function MINIMUM_LIQUIDITY() external pure returns (uint);

    /**
     * @dev 返回工厂地址
     * @return address 工厂合约地址
     */
    function factory() external view returns (address);

    /**
     * @dev 返回 token0 地址
     * @return address token0 地址
     */
    function token0() external view returns (address);

    /**
     * @dev 返回 token1 地址
     * @return address token1 地址
     */
    function token1() external view returns (address);

    /**
     * @dev 获取交易对储备量
     * @return reserve0 token0 储备
     * @return reserve1 token1 储备
     * @return blockTimestampLast 上次区块时间戳
     */
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    /**
     * @dev 返回累积价格0
     * @return uint 累积价格0
     */
    function price0CumulativeLast() external view returns (uint);

    /**
     * @dev 返回累积价格1
     * @return uint 累积价格1
     */
    function price1CumulativeLast() external view returns (uint);

    /**
     * @dev 返回 k 值
     * @return uint k 值
     */
    function kLast() external view returns (uint);

    /**
     * @dev 铸造流动性代币
     * @param to 接收地址
     * @return uint 铸造的流动性数量
     */
    function mint(address to) external returns (uint liquidity);

    /**
     * @dev 销毁流动性代币
     * @param to 接收地址
     * @return uint amount0 token0 数量
     * @return uint amount1 token1 数量
     */
    function burn(address to) external returns (uint amount0, uint amount1);

    /**
     * @dev 交易 swap
     * @param amount0Out 输出 token0 数量
     * @param amount1Out 输出 token1 数量
     * @param to 接收地址
     * @param data 回调数据
     */
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    /**
     * @dev 转移多余代币到指定地址
     * @param to 接收地址
     */
    function skim(address to) external;

    /**
     * @dev 同步储备量
     */
    function sync() external;

    /**
     * @dev 初始化交易对
     * @param tokenA tokenA 地址
     * @param tokenB tokenB 地址
     */
    function initialize(address tokenA, address tokenB) external;
}


/**
 * @title IUniswapV2Router01
 * @notice Uniswap V2 Router01 接口
 */
interface IUniswapV2Router01 {

    /**
     * @dev 返回工厂合约地址
     * @return address 工厂合约地址
     */
    function factory() external pure returns (address);

    /**
     * @dev 返回 WETH 合约地址
     * @return address WETH 地址
     */
    function WETH() external pure returns (address);

    /**
     * @dev 添加代币流动性
     * @param tokenA 代币 A 地址
     * @param tokenB 代币 B 地址
     * @param amountADesired 想要添加的 A 数量
     * @param amountBDesired 想要添加的 B 数量
     * @param amountAMin 最小添加的 A 数量
     * @param amountBMin 最小添加的 B 数量
     * @param to 接收流动性代币地址
     * @param deadline 截止时间
     * @return amountA 实际添加的 A 数量
     * @return amountB 实际添加的 B 数量
     * @return liquidity 铸造的流动性代币数量
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
     * @dev 添加 ETH 流动性
     * @param token 代币地址
     * @param amountTokenDesired 想要添加的代币数量
     * @param amountTokenMin 最小添加代币数量
     * @param amountETHMin 最小添加 ETH 数量
     * @param to 接收流动性代币地址
     * @param deadline 截止时间
     * @return amountToken 实际添加代币数量
     * @return amountETH 实际添加 ETH 数量
     * @return liquidity 铸造的流动性代币数量
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
     * @dev 移除流动性
     * @param tokenA 代币 A 地址
     * @param tokenB 代币 B 地址
     * @param liquidity 移除的流动性数量
     * @param amountAMin 最小接收 A 数量
     * @param amountBMin 最小接收 B 数量
     * @param to 接收代币地址
     * @param deadline 截止时间
     * @return amountA 实际接收 A 数量
     * @return amountB 实际接收 B 数量
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
     * @dev 移除 ETH 流动性
     * @param token 代币地址
     * @param liquidity 移除流动性数量
     * @param amountTokenMin 最小接收代币数量
     * @param amountETHMin 最小接收 ETH 数量
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amountToken 实际接收代币数量
     * @return amountETH 实际接收 ETH 数量
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
     * @dev 移除流动性并使用 permit 授权
     * @param tokenA 代币 A 地址
     * @param tokenB 代币 B 地址
     * @param liquidity 移除流动性数量
     * @param amountAMin 最小接收 A 数量
     * @param amountBMin 最小接收 B 数量
     * @param to 接收地址
     * @param deadline 截止时间
     * @param approveMax 是否批准最大值
     * @param v 签名 v
     * @param r 签名 r
     * @param s 签名 s
     * @return amountA 实际接收 A 数量
     * @return amountB 实际接收 B 数量
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
     * @dev 移除 ETH 流动性并使用 permit 授权
     * @param token 代币地址
     * @param liquidity 移除流动性数量
     * @param amountTokenMin 最小接收代币数量
     * @param amountETHMin 最小接收 ETH 数量
     * @param to 接收地址
     * @param deadline 截止时间
     * @param approveMax 是否批准最大值
     * @param v 签名 v
     * @param r 签名 r
     * @param s 签名 s
     * @return amountToken 实际接收代币数量
     * @return amountETH 实际接收 ETH 数量
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
     * @dev 精确代币交换
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出代币数量
     * @param path 交易路径
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amounts 各步交易实际数量
     */
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 按输出精确代币交换
     * @param amountOut 目标输出数量
     * @param amountInMax 最大输入数量
     * @param path 交易路径
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amounts 各步交易实际数量
     */
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 精确 ETH 换代币
     * @param amountOutMin 最小输出代币数量
     * @param path 交易路径
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amounts 各步交易实际数量
     */
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    /**
     * @dev 代币换取精确 ETH
     * @param amountOut 精确输出 ETH 数量
     * @param amountInMax 最大输入代币数量
     * @param path 交易路径
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amounts 各步交易实际数量
     */
    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev 精确代币换 ETH
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出 ETH 数量
     * @param path 交易路径
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amounts 各步交易实际数量
     */
    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    /**
     * @dev ETH 换取精确代币
     * @param amountOut 精确输出代币数量
     * @param path 交易路径
     * @param to 接收地址
     * @param deadline 截止时间
     * @return amounts 各步交易实际数量
     */
    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    /**
     * @dev 根据储备计算等价数量
     * @param amountA 数量 A
     * @param reserveA 储备 A
     * @param reserveB 储备 B
     * @return amountB 对应数量 B
     */
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    /**
     * @dev 计算输出代币数量
     * @param amountIn 输入数量
     * @param reserveIn 输入储备
     * @param reserveOut 输出储备
     * @return amountOut 输出数量
     */
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    /**
     * @dev 计算输入代币数量
     * @param amountOut 输出数量
     * @param reserveIn 输入储备
     * @param reserveOut 输出储备
     * @return amountIn 输入数量
     */
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    /**
     * @dev 计算多个路径输出数量
     * @param amountIn 输入数量
     * @param path 交易路径
     * @return amounts 每步输出数量
     */
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    /**
     * @dev 计算多个路径输入数量
     * @param amountOut 输出数量
     * @param path 交易路径
     * @return amounts 每步输入数量
     */
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IUniswapV2Router02 is IUniswapV2Router01 {

    /**
     * @dev 移除 ETH 流动性（支持带手续费的代币转账）
     * @param token 代币地址
     * @param liquidity 要移除的流动性数量
     * @param amountTokenMin 最小接收代币数量
     * @param amountETHMin 最小接收 ETH 数量
     * @param to 接收地址
     * @param deadline 截止时间（过期无效）
     * @return amountETH 实际接收到的 ETH 数量
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
     * @dev 使用 permit 授权的方式移除 ETH 流动性（支持带手续费代币）
     * @param token 代币地址
     * @param liquidity 移除流动性数量
     * @param amountTokenMin 最小接收代币数量
     * @param amountETHMin 最小接收 ETH 数量
     * @param to 接收地址
     * @param deadline 截止时间
     * @param approveMax 是否授权最大额度
     * @param v 签名 v 值
     * @param r 签名 r 值
     * @param s 签名 s 值
     * @return amountETH 实际接收的 ETH 数量
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
     * @dev 精确输入代币数量进行代币兑换（支持带手续费的代币）
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出代币数量
     * @param path 交易路径（代币地址数组）
     * @param to 接收地址
     * @param deadline 截止时间
     */
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    /**
     * @dev 精确输入 ETH 进行代币兑换（支持带手续费的代币）
     * @param amountOutMin 最小输出代币数量
     * @param path 交易路径（ETH→Token）
     * @param to 接收地址
     * @param deadline 截止时间
     */
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    /**
     * @dev 精确输入代币兑换 ETH（支持带手续费的代币）
     * @param amountIn 输入代币数量
     * @param amountOutMin 最小输出 ETH 数量
     * @param path 交易路径（Token→ETH）
     * @param to 接收地址
     * @param deadline 截止时间
     */
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

/**
 * @title IERC20
 * @dev ERC20 标准接口定义，包含事件与基础代币操作
 */
interface IERC20 {
    /**
     * @dev 当账户授权 spender 操作其代币时触发
     * @param owner 授权发起者地址
     * @param spender 被授权的地址
     * @param value 授权的代币数量
     */
    event Approval(address indexed owner, address indexed spender, uint value);

    /**
     * @dev 当代币转移时触发
     * @param from 转出地址
     * @param to 接收地址
     * @param value 转移的代币数量
     */
    event Transfer(address indexed from, address indexed to, uint value);

    /**
     * @dev 获取代币名称
     * @return string memory 代币名称
     */
    function name() external view returns (string memory);

    /**
     * @dev 获取代币符号
     * @return string memory 代币符号
     */
    function symbol() external view returns (string memory);

    /**
     * @dev 获取代币精度（小数位数）
     * @return uint8 精度值
     */
    function decimals() external view returns (uint8);

    /**
     * @dev 返回代币总供应量
     * @return uint 总供应量
     */
    function totalSupply() external view returns (uint);

    /**
     * @dev 查询指定地址余额
     * @param owner 查询的账户地址
     * @return uint 账户余额
     */
    function balanceOf(address owner) external view returns (uint);

    /**
     * @dev 查询授权额度
     * @param owner 授权人地址
     * @param spender 被授权人地址
     * @return uint 授权额度
     */
    function allowance(address owner, address spender) external view returns (uint);

    /**
     * @dev 授权 spender 可花费指定数量代币
     * @param spender 被授权人地址
     * @param value 授权代币数量
     * @return bool 是否成功
     */
    function approve(address spender, uint value) external returns (bool);

    /**
     * @dev 从调用者账户转账代币
     * @param to 接收地址
     * @param value 转账数量
     * @return bool 是否成功
     */
    function transfer(address to, uint value) external returns (bool);

    /**
     * @dev 从指定地址转账代币
     * @param from 转出地址
     * @param to 接收地址
     * @param value 转账数量
     * @return bool 是否成功
     */
    function transferFrom(address from, address to, uint value) external returns (bool);
}

/**
 * @title IWETH
 * @dev Wrapped ETH (WETH) 接口定义，用于将 ETH 封装成 ERC20 代币
 */
interface IWETH {
    /**
     * @dev 存入 ETH 并铸造等量 WETH
     */
    function deposit() external payable;

    /**
     * @dev 转移 WETH 代币
     * @param to 接收地址
     * @param value 转账数量
     * @return bool 是否成功
     */
    function transfer(address to, uint value) external returns (bool);

    /**
     * @dev 提取 ETH，将指定数量 WETH 兑换回原生 ETH
     * @param value 要提取的 WETH 数量
     */
    function withdraw(uint value) external;
}

contract UniswapV2Router02 is IUniswapV2Router02 {
    using SafeMath for uint;

    address public immutable override factory;
    address public immutable override WETH;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
        _;
    }

    constructor(address _factory, address _WETH) public {
        factory = _factory;
        WETH = _WETH;
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin
    ) internal virtual returns (uint amountA, uint amountB) {
        // create the pair if it doesn't exist yet
        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
            IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        }
        (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
        liquidity = IUniswapV2Pair(pair).mint(to);
    }
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
        (amountToken, amountETH) = _addLiquidity(
            token,
            WETH,
            amountTokenDesired,
            msg.value,
            amountTokenMin,
            amountETHMin
        );
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
        IWETH(WETH).deposit{value: amountETH}();
        assert(IWETH(WETH).transfer(pair, amountETH));
        liquidity = IUniswapV2Pair(pair).mint(to);
        // refund dust eth, if any
        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
    }

    // **** REMOVE LIQUIDITY ****
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
        (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
        (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
        require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
        require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
    }
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
        (amountToken, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        TransferHelper.safeTransfer(token, to, amountToken);
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external virtual override returns (uint amountA, uint amountB) {
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
    }
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external virtual override returns (uint amountToken, uint amountETH) {
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
    }

    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) public virtual override ensure(deadline) returns (uint amountETH) {
        (, amountETH) = removeLiquidity(
            token,
            WETH,
            liquidity,
            amountTokenMin,
            amountETHMin,
            address(this),
            deadline
        );
        TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external virtual override returns (uint amountETH) {
        address pair = UniswapV2Library.pairFor(factory, token, WETH);
        uint value = approveMax ? uint(-1) : liquidity;
        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
            token, liquidity, amountTokenMin, amountETHMin, to, deadline
        );
    }

    // **** SWAP ****
    // requires the initial amount to have already been sent to the first pair
    function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            uint amountOut = amounts[i + 1];
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
                amount0Out, amount1Out, to, new bytes(0)
            );
        }
    }
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, to);
    }
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, to);
    }
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        virtual
        override
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
        amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
    }
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        virtual
        override
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        virtual
        override
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        virtual
        override
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
        require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
    }

    // **** SWAP (supporting fee-on-transfer tokens) ****
    // requires the initial amount to have already been sent to the first pair
    function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (address input, address output) = (path[i], path[i + 1]);
            (address token0,) = UniswapV2Library.sortTokens(input, output);
            IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
            uint amountInput;
            uint amountOutput;
            { // scope to avoid stack too deep errors
            (uint reserve0, uint reserve1,) = pair.getReserves();
            (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
            amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
            amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
            }
            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
            pair.swap(amount0Out, amount1Out, to, new bytes(0));
        }
    }
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual override ensure(deadline) {
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
        );
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, to);
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
        );
    }
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        virtual
        override
        payable
        ensure(deadline)
    {
        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
        uint amountIn = msg.value;
        IWETH(WETH).deposit{value: amountIn}();
        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
        _swapSupportingFeeOnTransferTokens(path, to);
        require(
            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
            'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
        );
    }
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    )
        external
        virtual
        override
        ensure(deadline)
    {
        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
        TransferHelper.safeTransferFrom(
            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
        );
        _swapSupportingFeeOnTransferTokens(path, address(this));
        uint amountOut = IERC20(WETH).balanceOf(address(this));
        require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
        IWETH(WETH).withdraw(amountOut);
        TransferHelper.safeTransferETH(to, amountOut);
    }

    // **** LIBRARY FUNCTIONS ****
    function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
        return UniswapV2Library.quote(amountA, reserveA, reserveB);
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
        public
        pure
        virtual
        override
        returns (uint amountOut)
    {
        return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
    }

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
        public
        pure
        virtual
        override
        returns (uint amountIn)
    {
        return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
    }

    function getAmountsOut(uint amountIn, address[] memory path)
        public
        view
        virtual
        override
        returns (uint[] memory amounts)
    {
        return UniswapV2Library.getAmountsOut(factory, amountIn, path);
    }

    function getAmountsIn(uint amountOut, address[] memory path)
        public
        view
        virtual
        override
        returns (uint[] memory amounts)
    {
        return UniswapV2Library.getAmountsIn(factory, amountOut, path);
    }
}

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                IUniswapV2Factory(factory).initCodeHash()
                // hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
       (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(997);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
        // IERC20(token).transferFrom(from, to, value);
   }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}