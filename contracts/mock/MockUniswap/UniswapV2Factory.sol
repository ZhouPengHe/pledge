
// SPDX-License-Identifier: MIT
pragma solidity =0.5.16;

/**
 * @title IUniswapV2Factory
 * @dev 工厂接口，包含配对创建与查询方法。
 */
interface IUniswapV2Factory {
    /**
     * @dev 返回初始化代码哈希值（用于预计算 CREATE2 地址）
     * @return bytes32 init code hash
     */
    function initCodeHash() external pure returns (bytes32);
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    /**
     * @dev 返回手续费接收地址
     * @return address 手续费接收地址
     */
    function feeTo() external view returns (address);
    /**
     * @dev 返回可以设置 feeTo 的管理员地址
     * @return address feeToSetter 地址
     */
    function feeToSetter() external view returns (address);

    /**
     * @dev 查询两个代币的配对合约地址
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @return pair 配对合约地址
     */
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    /**
     * @dev 按索引返回 allPairs 数组中的配对合约地址
     * @param uint 索引
     * @return pair 配对合约地址
     */
    function allPairs(uint) external view returns (address pair);
    /**
     * @dev 返回已创建配对的数量
     * @return uint 配对总数
     */
    function allPairsLength() external view returns (uint);

    /**
     * @dev 创建一个新的代币配对合约
     * @param tokenA 代币A地址
     * @param tokenB 代币B地址
     * @return pair 新创建的配对合约地址
     */
    function createPair(address tokenA, address tokenB) external returns (address pair);

    /**
     * @dev 设置手续费接收地址
     * @param address 新的 feeTo 地址
     */
    function setFeeTo(address) external;
    /**
     * @dev 设置 feeToSetter 管理员地址
     * @param address 新的 feeToSetter 地址
     */
    function setFeeToSetter(address) external;
}

/**
 * @title IUniswapV2Pair
 * @dev Pair 接口，包含流动性、交换等方法
 */
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    /**
     * @dev 返回代币对名称
     * @return string 内部名称
     */
    function name() external pure returns (string memory);
    /**
     * @dev 返回代币对符号
     * @return string 符号
     */
    function symbol() external pure returns (string memory);
    /**
     * @dev 返回精度（小数位）
     * @return uint8 小数位
     */
    function decimals() external pure returns (uint8);
    /**
     * @dev 返回总供应量
     * @return uint 总供应量
     */
    function totalSupply() external view returns (uint);
    /**
     * @dev 查询地址余额
     * @param owner 地址
     * @return uint 余额
     */
    function balanceOf(address owner) external view returns (uint);
    /**
     * @dev 查询 spender 的授权额度
     * @param owner 授权人地址
     * @param spender 被授权地址
     * @return uint 授权额度
     */
    function allowance(address owner, address spender) external view returns (uint);

    /**
     * @dev 授权 spender 转移 value 数量代币
     * @param spender 被授权地址
     * @param value 授权数量
     * @return bool 操作是否成功
     */
    function approve(address spender, uint value) external returns (bool);
    /**
     * @dev 将代币转移到 to
     * @param to 接收地址
     * @param value 转移数量
     * @return bool 操作是否成功
     */
    function transfer(address to, uint value) external returns (bool);
    /**
     * @dev 从 from 转移代币到 to（需先授权）
     * @param from 源地址
     * @param to 目标地址
     * @param value 转移数量
     * @return bool 操作是否成功
     */
    function transferFrom(address from, address to, uint value) external returns (bool);

    /**
     * @dev EIP712 域分隔符
     * @return bytes32 域分隔符
     */
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    /**
     * @dev permit 类型哈希
     * @return bytes32 permit 类型哈希
     */
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    /**
     * @dev 查询地址的 nonce（用于 permit）
     * @param owner 地址
     * @return uint nonce 值
     */
    function nonces(address owner) external view returns (uint);

    /**
     * @dev permit 签名授权
     * @param owner 授权人地址
     * @param spender 被授权地址
     * @param value 授权数量
     * @param deadline 截止时间（timestamp）
     * @param v 签名 v
     * @param r 签名 r
     * @param s 签名 s
     */
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    /**
     * @dev 返回最小流动性常量
     * @return uint 最小流动性
     */
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    /**
     * @dev 返回工厂合约地址
     * @return address 工厂地址
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
     * @dev 获取储备量和时间戳
     * @return reserve0 储备0
     * @return reserve1 储备1
     * @return blockTimestampLast 最后更新时间戳
     */
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    /**
     * @dev 返回累积价格（token0）
     * @return uint price0 累积价格
     */
    function price0CumulativeLast() external view returns (uint);
    /**
     * @dev 返回累积价格（token1）
     * @return uint price1 累积价格
     */
    function price1CumulativeLast() external view returns (uint);
    /**
     * @dev 返回 kLast（最近一次流动性事件后的储备乘积）
     * @return uint kLast 值
     */
    function kLast() external view returns (uint);

    /**
     * @dev 铸造流动性代币
     * @param to 接收铸造的地址
     * @return liquidity 铸造数量
     */
    function mint(address to) external returns (uint liquidity);
    /**
     * @dev 销毁流动性代币并返回两种代币数量
     * @param to 接收销毁后代币的地址
     * @return amount0 token0 数量
     * @return amount1 token1 数量
     */
    function burn(address to) external returns (uint amount0, uint amount1);
    /**
     * @dev 执行交换
     * @param amount0Out token0 输出数量
     * @param amount1Out token1 输出数量
     * @param to 接收地址
     * @param data 回调数据
     */
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    /**
     * @dev 把合约余额的多余部分转移到 to（用于清理）
     * @param to 接收地址
     */
    function skim(address to) external;
    /**
     * @dev 同步储备为当前余额
     */
    function sync() external;

    /**
     * @dev 初始化配对合约（由工厂调用）
     * @param address token0 地址
     * @param address token1 地址
     */
    function initialize(address, address) external;
}

/**
 * @title IUniswapV2ERC20
 * @dev ERC20 接口（用于 Pair 内部）
 */
interface IUniswapV2ERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}

/**
 * @title IERC20
 * @dev 精简 ERC20 接口，用于外部调用
 */
interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

/**
 * @title IUniswapV2Callee
 * @dev 回调接口，供闪电贷等使用
 */
interface IUniswapV2Callee {
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

/**
 * @title UniswapV2ERC20
 * @dev Pair 使用的 ERC20 实现（带 permit）
 */
contract UniswapV2ERC20 is IUniswapV2ERC20 {
    using SafeMath for uint;

    // 合约名称
    string public constant name = 'Uniswap V2';
    // 合约符号
    string public constant symbol = 'UNI-V2';
    // 小数位
    uint8 public constant decimals = 18;
    // 总供应量
    uint  public totalSupply;
    // 地址余额映射
    mapping(address => uint) public balanceOf;
    // 授权映射 owner => spender => amount
    mapping(address => mapping(address => uint)) public allowance;

    // EIP712 域分隔符
    bytes32 public DOMAIN_SEPARATOR;
    // permit 类型哈希（常量）
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    // nonces 映射（用于 permit）
    mapping(address => uint) public nonces;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    /**
     * @dev 构造函数：初始化 DOMAIN_SEPARATOR
     */
    constructor() public {
        uint chainId;
        // 获取链ID（使用内联汇编）
        assembly {
            chainId := chainid
        }
        // 计算 EIP712 域分隔符
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    /**
     * @dev 内部铸币方法
     * @param to 接收地址
     * @param value 铸造数量
     */
    function _mint(address to, uint value) internal {
        // 增加总供应量
        totalSupply = totalSupply.add(value);
        // 增加接收地址余额
        balanceOf[to] = balanceOf[to].add(value);
        // 触发转移事件（从 0 地址）
        emit Transfer(address(0), to, value);
    }

    /**
     * @dev 内部销毁方法
     * @param from 销毁来源地址
     * @param value 销毁数量
     */
    function _burn(address from, uint value) internal {
        // 从余额中减去
        balanceOf[from] = balanceOf[from].sub(value);
        // 总供应量减少
        totalSupply = totalSupply.sub(value);
        // 触发转移到 0 地址的事件
        emit Transfer(from, address(0), value);
    }

    /**
     * @dev 内部设置授权
     * @param owner 授权人地址
     * @param spender 被授权地址
     * @param value 授权数量
     */
    function _approve(address owner, address spender, uint value) private {
        // 更新授权映射
        allowance[owner][spender] = value;
        // 触发 Approval 事件
        emit Approval(owner, spender, value);
    }

    /**
     * @dev 内部转账方法
     * @param from 源地址
     * @param to 目标地址
     * @param value 转移数量
     */
    function _transfer(address from, address to, uint value) private {
        // 从发送者减去余额
        balanceOf[from] = balanceOf[from].sub(value);
        // 给接收者加上余额
        balanceOf[to] = balanceOf[to].add(value);
        // 触发转账事件
        emit Transfer(from, to, value);
    }

    /**
     * @dev ERC20 approve 实现
     */
    function approve(address spender, uint value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev ERC20 transfer 实现
     */
    function transfer(address to, uint value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev ERC20 transferFrom 实现（支持无限授权表示 uint(-1)）
     */
    function transferFrom(address from, address to, uint value) external returns (bool) {
        // 如果不是无限授权，需要减少 allowance
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev permit 签名授权实现
     * @param owner 授权人地址
     * @param spender 被授权地址
     * @param value 授权数量
     * @param deadline 截止时间（timestamp）
     * @param v 签名 v
     * @param r 签名 r
     * @param s 签名 s
     */
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        // 检查签名是否过期
        require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
        // 计算 digest
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        // 恢复签名地址
        address recoveredAddress = ecrecover(digest, v, r, s);
        // 验证签名地址是否有效且为 owner
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
        // 设置授权
        _approve(owner, spender, value);
    }
}

/**
 * @title UniswapV2Pair
 * @dev 核心配对合约，包含流动性铸造、销毁、交换等逻辑
 */
contract UniswapV2Pair is IUniswapV2Pair, UniswapV2ERC20 {
    using SafeMath  for uint;
    using UQ112x112 for uint224;

    // 最小流动性常量
    uint public constant MINIMUM_LIQUIDITY = 10**3;
    // ERC20 transfer 选择器
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    // 工厂合约地址（部署时由工厂传入）
    address public factory;
    // 代币地址
    address public token0;
    address public token1;

    // 储备（单槽存储）
    uint112 private reserve0;
    uint112 private reserve1;
    // 最后区块时间戳
    uint32  private blockTimestampLast;

    // 累计价格变量
    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    // k 的上一次记录（用于手续费计算）
    uint public kLast;

    // 互斥锁状态
    uint private unlocked = 1;
    modifier lock() {
        // 确保没有重入
        require(unlocked == 1, 'UniswapV2: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    /**
     * @dev 获取当前储备量与时间戳
     * @return _reserve0 储备0
     * @return _reserve1 储备1
     * @return _blockTimestampLast 最后更新时间戳
     */
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        // 直接返回存储的储备和时间戳
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    /**
     * @dev 安全转账内部函数（处理 ERC20 可能不返回 bool 的实现）
     * @param token 代币地址
     * @param to 接收地址
     * @param value 转移数量
     */
    function _safeTransfer(address token, address to, uint value) private {
        // 调用 token.transfer(to, value)
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
        // 检查执行成功且要么没有返回数据，要么返回 true
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
    }

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    /**
     * @dev 构造函数：设置 factory
     */
    constructor() public {
        // 部署者为工厂合约
        factory = msg.sender;
    }

    /**
     * @dev 初始化 token0 和 token1（仅工厂可调用）
     * @param _token0 token0 地址
     * @param _token1 token1 地址
     */
    function initialize(address _token0, address _token1) external {
        // 仅工厂允许初始化
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN');
        token0 = _token0;
        token1 = _token1;
    }

    /**
     * @dev 更新储备并在每个区块首次调用时更新累积价格
     * @param balance0 token0 当前余额
     * @param balance1 token1 当前余额
     * @param _reserve0 上一次储备0
     * @param _reserve1 上一次储备1
     */
    function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
        // 确保余额不超过 uint112 最大值
        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
        // 取得当前区块时间戳（取模 2**32）
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        // 计算时间差（期望溢出行为）
        uint32 timeElapsed = blockTimestamp - blockTimestampLast;
        // 如果经过时间大于0且之前储备非零，则累积价格
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // 更新累积价格（不会溢出）
            price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
        }
        // 更新储备与时间戳
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        // 触发同步事件
        emit Sync(reserve0, reserve1);
    }

    /**
     * @dev 根据 feeTo 是否开启，铸造相当于增长的 1/6 的流动性给 feeTo
     * @param _reserve0 更新前的储备0
     * @param _reserve1 更新前的储备1
     * @return feeOn 是否开启手续费分配
     */
    function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
        // 查询工厂的 feeTo 地址
        address feeTo = IUniswapV2Factory(factory).feeTo();
        // 如果 feeTo 非零地址，则表示开启
        feeOn = feeTo != address(0);
        uint _kLast = kLast; // 缓存 kLast 减少 gas
        if (feeOn) {
            if (_kLast != 0) {
                // 计算根号 k
                uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
                uint rootKLast = Math.sqrt(_kLast);
                // 如果当前 rootK 大于上次 rootK，则按比例给 feeTo 铸币
                if (rootK > rootKLast) {
                    uint numerator = totalSupply.mul(rootK.sub(rootKLast));
                    uint denominator = rootK.mul(5).add(rootKLast);
                    uint liquidity = numerator / denominator;
                    if (liquidity > 0) _mint(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            // 如果关闭手续费且之前有 kLast，则清零
            kLast = 0;
        }
    }

    /**
     * @dev 铸造流动性代币（由外部调用）
     * @param to 接收铸造的地址
     * @return liquidity 铸造数量
     */
    function mint(address to) external lock returns (uint liquidity) {
        // 获取当前储备（用于计算新增数量）
        (uint112 _reserve0, uint112 _reserve1,) = getReserves();
        // 查询合约当前持仓
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));
        // 计算新增的数量
        uint amount0 = balance0.sub(_reserve0);
        uint amount1 = balance1.sub(_reserve1);

        // 如果开启手续费，先铸造 fee 部分
        bool feeOn = _mintFee(_reserve0, _reserve1);
        // 缓存总供应量（gas 优化）
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            // 初次提供流动性：计算初始流动性并烧掉 MINIMUM_LIQUIDITY
            liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
            _mint(address(0), MINIMUM_LIQUIDITY); // 永久锁住最小流动性
        } else {
            // 按比例计算流动性
            liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
        }
        // 确保流动性大于0
        require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
        // 铸造流动性代币给 to
        _mint(to, liquidity);

        // 更新储备并在需要时更新 kLast
        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).mul(reserve1); // 更新 kLast
        // 触发 Mint 事件
        emit Mint(msg.sender, amount0, amount1);
    }

    /**
     * @dev 销毁流动性代币并返回两种代币数量
     * @param to 接收地址
     * @return amount0 token0 数量
     * @return amount1 token1 数量
     */
    function burn(address to) external lock returns (uint amount0, uint amount1) {
        // 读取当前储备
        (uint112 _reserve0, uint112 _reserve1,) = getReserves();
        // 缓存代币地址以节省 gas
        address _token0 = token0;
        address _token1 = token1;
        // 当前合约中对应代币余额
        uint balance0 = IERC20(_token0).balanceOf(address(this));
        uint balance1 = IERC20(_token1).balanceOf(address(this));
        // 合约自身持有的流动性代币数量
        uint liquidity = balanceOf[address(this)];

        // 处理手续费
        bool feeOn = _mintFee(_reserve0, _reserve1);
        // 缓存总供应量
        uint _totalSupply = totalSupply;
        // 计算按比例应得的 token 数量
        amount0 = liquidity.mul(balance0) / _totalSupply;
        amount1 = liquidity.mul(balance1) / _totalSupply;
        // 确保输出量大于0
        require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
        // 销毁配对的流动性代币
        _burn(address(this), liquidity);
        // 安全转账到 to
        _safeTransfer(_token0, to, amount0);
        _safeTransfer(_token1, to, amount1);
        // 更新余额
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));

        // 更新储备并更新 kLast（如果需要）
        _update(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).mul(reserve1);
        // 触发 Burn 事件
        emit Burn(msg.sender, amount0, amount1, to);
    }

    /**
     * @dev 低级交换函数（外部调用）
     * @param amount0Out token0 输出数量
     * @param amount1Out token1 输出数量
     * @param to 接收地址
     * @param data 回调数据（如果非空并且 to 是合约，则调用回调）
     */
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
        // 输出量必须至少有一种大于0
        require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
        // 读取当前储备
        (uint112 _reserve0, uint112 _reserve1,) = getReserves();
        // 验证输出量不能超过储备
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        { // 限定作用域以避免栈深度过深
            address _token0 = token0;
            address _token1 = token1;
            // 确保接收地址不是代币地址（防止转到代币合约）
            require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
            // 乐观转账（先转出）
            if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out);
            if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out);
            // 如果 data 非空，则执行回调（闪电贷场景）
            if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
            // 读取转账后的余额
            balance0 = IERC20(_token0).balanceOf(address(this));
            balance1 = IERC20(_token1).balanceOf(address(this));
        }
        // 计算输入量（判断余额变化）
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        // 必须有输入量
        require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
        { // 限定作用域，避免栈过深
            // 按 0.3% 手续费调整余额（乘以 1000 并减去输入量 * 3）
            uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(3));
            uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(3));
            // 保证恒定乘积不变（考虑手续费）
            require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
        }

        // 更新储备并触发 Swap 事件
        _update(balance0, balance1, _reserve0, _reserve1);
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    /**
     * @dev 清理合约中多余的余额到指定地址
     * @param to 接收地址
     */
    function skim(address to) external lock {
        address _token0 = token0;
        address _token1 = token1;
        // 将合约余额中超过储备的部分转给 to
        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
    }

    /**
     * @dev 强制同步储备为当前余额
     */
    function sync() external lock {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
    }
}

/**
 * @title UniswapV2Factory
 * @dev 工厂合约：创建并管理配对合约
 */
contract UniswapV2Factory is IUniswapV2Factory {
    // 手续费接收地址
    address public feeTo;
    // 管理员地址
    address public feeToSetter;
    // init code hash（用于 CREATE2 地址计算）
    bytes32 public initCodeHash;

    // 代币对映射（tokenA => tokenB => pair）
    mapping(address => mapping(address => address)) public getPair;
    // 存储所有配对地址
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    /**
     * @dev 构造函数：设置管理员并计算 initCodeHash
     * @param _feeToSetter 管理员地址
     */
    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
        // 计算配对合约的创建代码哈希
        initCodeHash = keccak256(abi.encodePacked(type(UniswapV2Pair).creationCode));
    }

    /**
     * @dev 返回配对数量
     * @return uint 配对数量
     */
    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    /**
     * @dev 创建配对合约（使用 CREATE2）
     * @param tokenA 代币A 地址
     * @param tokenB 代币B 地址
     * @return pair 新创建的配对合约地址
     */
    function createPair(address tokenA, address tokenB) external returns (address pair) {
        // 代币地址不能相同
        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');
        // 将地址排序以保证唯一性
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        // token0 不能是 0 地址
        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
        // 确保配对不存在
        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS');
        // 获取配对合约字节码
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        // salt 为 token0 与 token1 的哈希
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            // 使用 CREATE2 部署合约
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        // 初始化配对合约
        IUniswapV2Pair(pair).initialize(token0, token1);
        // 在映射中保存双向映射
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        // 将配对地址加入数组
        allPairs.push(pair);

        // 触发事件，allPairs.length 为当前长度
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    /**
     * @dev 设置手续费接收地址（仅管理员可调用）
     * @param _feeTo 新的 feeTo 地址
     */
    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    /**
     * @dev 设置管理员（仅当前管理员可调用）
     * @param _feeToSetter 新的管理员地址
     */
    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}

/**
 * @title SafeMath
 * @dev 安全的算术运算（溢出检查）
 */
library SafeMath {
    /**
     * @dev 安全加法
     */
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    /**
     * @dev 安全减法
     */
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    /**
     * @dev 安全乘法
     */
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

/**
 * @title Math
 * @dev 通用数学工具
 */
library Math {
    /**
     * @dev 返回两个数中较小者
     */
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    /**
     * @dev 计算平方根（Babylonian 方法）
     */
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

/**
 * @title UQ112x112
 * @dev 二进制定点数工具（Q112.112）
 */
library UQ112x112 {
    // Q112 常量
    uint224 constant Q112 = 2**112;

    /**
     * @dev 将 uint112 编码为 UQ112x112
     * @param y 输入值
     * @return z 编码后的 uint224
     */
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112;
    }

    /**
     * @dev 将 UQ112x112 除以 uint112，返回 UQ112x112
     * @param x 被除数（UQ112x112）
     * @param y 除数（uint112）
     * @return z 结果（uint224）
     */
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y);
    }
}