// Project imports:
import 'package:QRTest_v2_test1/bean/chain_config_bean.dart';

enum ChainEnum {
  arbitrum,
  arbitrumgoerli,
  arbitrumrinkeby,
  avalanchecchain,
  avalanchecchaintestnet,
  bnbsmartchain,
  bnbsmartchaintestnet,
  binancechain,
  bitcoin,
  bitcoinbech32,
  bitkubchain,
  bitkubchaintestnet,
  celo,
  celotestnet,
  cosmos,
  cosmostheta,
  cronos,
  cronostestnet,
  dummy,
  ethereum,
  ethereumgoerli,
  ethereumsepolia,
  ethereumclassic,
  ethereumclassictestnet,
  filecoin,
  filecointestnet,
  iovmainnet,
  liskmainnet,
  litecoin,
  okc,
  okctestnet,
  polygon,
  polygonmumbai,
  solana,
  solanatestnet,
  starknettestnet,
  tron,
}

// CAIP2 semantics
// https://github.com/ChainAgnostic/CAIPs/blob/main/CAIPs/caip-2.md
Map<ChainEnum, ChainConfigBean> caip2Map = {
  ChainEnum.arbitrum: ChainConfigBean(
    name: "Arbitrum",
    caip2Id: "eip155:42161",
    rpcUrl: "https://arb1.arbitrum.io/rpc",
    symbol: "ETH",
    blockExplorerUrl: "https://arbiscan.io/",
  ),
  ChainEnum.arbitrumgoerli: ChainConfigBean(
    name: "Arbitrum Goerli",
    caip2Id: "eip155:421613",
    rpcUrl: "https://goerli-rollup.arbitrum.io/rpc",
    symbol: "ETH",
    blockExplorerUrl: "https://arbiscan.io/",
  ),
  ChainEnum.arbitrumrinkeby: ChainConfigBean(
    name: "Arbitrum Rinkeby",
    caip2Id: "eip155:421611",
    rpcUrl: "https://rinkeby-rollup.arbitrum.io/rpc",
    symbol: "ETH",
    blockExplorerUrl: "https://arbiscan.io/",
  ),
  ChainEnum.avalanchecchain: ChainConfigBean(
    name: "Avalanche C-Chain",
    caip2Id: "eip155:43114",
    rpcUrl: "https://api.avax.network/ext/bc/C/rpc",
    symbol: "AVAX",
    blockExplorerUrl: "https://cchain.explorer.avax.network/",
  ),
  ChainEnum.avalanchecchaintestnet: ChainConfigBean(
    name: "Avalanche C-Chain Testnet",
    caip2Id: "eip155:43113",
    rpcUrl: "https://api.avax-test.network/ext/bc/C/rpc",
    symbol: "AVAX",
    blockExplorerUrl: "https://cchain.explorer.avax-test.network/",
  ),
  ChainEnum.bnbsmartchain: ChainConfigBean(
    name: "Binance Smart Chain",
    caip2Id: "eip155:56",
    rpcUrl: "https://bsc-dataseed2.binance.org",
    symbol: "BNB",
    blockExplorerUrl: "https://bscscan.com/",
  ),
  ChainEnum.bnbsmartchaintestnet: ChainConfigBean(
    name: "Binance Smart Chain Testnet",
    caip2Id: "eip155:97",
    rpcUrl: "https://data-seed-prebsc-1-s1.binance.org:8545",
    symbol: "BNB",
    blockExplorerUrl: "https://testnet.bscscan.com/",
  ),
  ChainEnum.binancechain: ChainConfigBean(
    name: "Binance Chain",
    caip2Id: "bip122:bnb", //"cosmos:Binance-Chain-Tigris"
    rpcUrl: "https://bsc-dataseed.binance.org/",
    symbol: "BNB",
    blockExplorerUrl: "https://bscscan.com/",
  ),
  ChainEnum.bitcoin: ChainConfigBean(
    name: "Bitcoin",
    caip2Id: "bip122:000000000019d6689c085ae165831e93",
    rpcUrl: "https://bsc-dataseed.binance.org/",
    symbol: "BTC",
    blockExplorerUrl: "https://bscscan.com/",
  ),
  ChainEnum.bitcoinbech32: ChainConfigBean(
    name: "Bitcoin Bech32",
    caip2Id: "bip122:bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4",
    rpcUrl: "https://bsc-dataseed.binance.org/",
    symbol: "BTC",
    blockExplorerUrl: "https://bscscan.com/",
  ),
  ChainEnum.bitkubchain: ChainConfigBean(
    name: "Bitkub Chain",
    caip2Id: "eip155:96",
    rpcUrl: "https://rpc.bitkubchain.io",
    symbol: "KUB",
    blockExplorerUrl: "https://explorer.bitkubchain.io/",
  ),
  ChainEnum.bitkubchaintestnet: ChainConfigBean(
    name: "Bitkub Chain Testnet",
    caip2Id: "eip155:25925",
    rpcUrl: "https://rpc-testnet.bitkubchain.io",
    symbol: "KUB",
    blockExplorerUrl: "https://explorer-testnet.bitkubchain.io/",
  ),
  ChainEnum.celo: ChainConfigBean(
    name: "Celo",
    caip2Id: "eip155:42220",
    rpcUrl: "https://forno.celo.org",
    symbol: "CELO",
    blockExplorerUrl: "https://explorer.celo.org/",
  ),
  ChainEnum.celotestnet: ChainConfigBean(
    name: "Celo Testnet",
    caip2Id: "eip155:44787",
    rpcUrl: "https://alfajores-forno.celo-testnet.org",
    symbol: "CELO",
    blockExplorerUrl: "https://alfajores-blockscout.celo-testnet.org/",
  ),
  ChainEnum.cosmos: ChainConfigBean(
    name: "Cosmos",
    caip2Id: "cosmos:cosmoshub-4",
    rpcUrl: "https://cosmos-mainnet-rpc.allthatnode.com:26657",
    symbol: "ATOM",
    blockExplorerUrl: "https://cosmos.bigdipper.live/",
  ),
  ChainEnum.cosmostheta: ChainConfigBean(
    name: "Cosmos Theta",
    caip2Id: "theta",
    rpcUrl: "https://cosmos-testnet-rpc.allthatnode.com:26657",
    symbol: "THETA",
    blockExplorerUrl: "https://explorer.cosmostheta.com/",
  ),
  ChainEnum.cronos: ChainConfigBean(
    name: "Cronos",
    caip2Id: "eip155:25",
    rpcUrl: "https://cronosrpc-1.xstaking.sg",
    symbol: "CRON",
    blockExplorerUrl: "https://cronos-explorer.crypto.org/",
  ),
  ChainEnum.cronostestnet: ChainConfigBean(
    name: "Cronos Testnet",
    caip2Id: "eip155:338",
    rpcUrl: "https://evm-t3.cronos.org",
    symbol: "CRON",
    blockExplorerUrl: "https://cronos-explorer.crypto.org/",
  ),
  ChainEnum.dummy: ChainConfigBean(
    name: "Dummy",
    caip2Id: "chainstd:8c3444cf8970a9e41a706fab93e7a6c4",
    rpcUrl: "https://rpc.cosmos.network",
    symbol: "DUMMY",
    blockExplorerUrl: "https://cosmos.bigdipper.live/",
  ),
  ChainEnum.ethereum: ChainConfigBean(
    name: "Ethereum",
    caip2Id: "eip155:1",
    rpcUrl: "https://mainnet.infura.io/v3/263915639f6745f7b63c7fcc1f47dc37",
    symbol: "ETH",
    blockExplorerUrl: "https://etherscan.io/",
  ),
  ChainEnum.ethereumgoerli: ChainConfigBean(
    name: "Ethereum Goerli",
    caip2Id: "eip155:5",
    rpcUrl: "https://goerli.infura.io/v3/263915639f6745f7b63c7fcc1f47dc37",
    symbol: "ETH",
    blockExplorerUrl: "https://goerli.etherscan.io/",
  ),
  ChainEnum.ethereumsepolia: ChainConfigBean(
    name: "Ethereum Sepolia",
    caip2Id: "eip155:11155111",
    rpcUrl: "https://sepolia.infura.io/v3/263915639f6745f7b63c7fcc1f47dc37",
    symbol: "ETH",
    blockExplorerUrl: "https://sepolia.net/",
  ),
  ChainEnum.ethereumclassic: ChainConfigBean(
    name: "Ethereum Classic",
    caip2Id: "eip155:61",
    rpcUrl: "https://etc.rivet.link",
    symbol: "ETC",
    blockExplorerUrl: "https://blockscout.com/etc/mainnet/",
  ),
  ChainEnum.ethereumclassictestnet: ChainConfigBean(
    name: "Ethereum Classic Testnet",
    caip2Id: "eip155:63",
    rpcUrl: "https://rpc.mordor.etccooperative.org",
    symbol: "ETC",
    blockExplorerUrl: "https://blockscout.com/etc/mainnet/",
  ),
  ChainEnum.filecoin: ChainConfigBean(
    name: "Filecoin",
    caip2Id: "eip155:314",
    rpcUrl: "https://api.node.glif.io",
    symbol: "FIL",
    blockExplorerUrl: "https://filscan.io/",
  ),
  ChainEnum.filecointestnet: ChainConfigBean(
    name: "Filecoin Testnet",
    caip2Id: "eip155:314159",
    rpcUrl: "https://api.calibration.node.glif.io/rpc/v1",
    symbol: "FIL",
    blockExplorerUrl: "https://calibration.filscan.io/",
  ),
  ChainEnum.iovmainnet: ChainConfigBean(
    name: "IOV Mainnet",
    caip2Id: "cosmos:iov-mainnet",
    rpcUrl: "https://rpc.iov-mainnet-2.iov.one",
    symbol: "IOV",
    blockExplorerUrl: "https://www.mintscan.io/iov",
  ),
  ChainEnum.liskmainnet: ChainConfigBean(
    name: "Lisk Mainnet",
    caip2Id: "lip9:9ee11e9df416b18b",
    rpcUrl: "https://node01.lisk.io",
    symbol: "LSK",
    blockExplorerUrl: "https://explorer.lisk.io/",
  ),
  ChainEnum.litecoin: ChainConfigBean(
    name: "Litecoin",
    caip2Id: "bip122:12a765e31ffd4059bada1e25190f6e98",
    rpcUrl: "https://electrum.blockstream.info:50002",
    symbol: "LTC",
    blockExplorerUrl: "https://bscscan.com/",
  ),
  ChainEnum.okc: ChainConfigBean(
    name: "OKC",
    caip2Id: "eip155:66",
    rpcUrl: "https://exchainrpc.okex.org",
    symbol: "OKT",
    blockExplorerUrl: "https://www.oklink.com/okexchain/",
  ),
  ChainEnum.okctestnet: ChainConfigBean(
    name: "OKC Testnet",
    caip2Id: "eip155:65",
    rpcUrl: "https://exchaintestrpc.okex.org",
    symbol: "OKT",
    blockExplorerUrl: "https://www.oklink.com/okexchain-test/",
  ),
  ChainEnum.polygon: ChainConfigBean(
    name: "Polygon",
    caip2Id: "eip155:137",
    rpcUrl: "https://polygon-rpc.com/",
    symbol: "MATIC",
    blockExplorerUrl: "https://polygonscan.com/",
  ),
  ChainEnum.polygonmumbai: ChainConfigBean(
    name: "Polygon Mumbai",
    caip2Id: "eip155:80001",
    rpcUrl: "https://rpc.ankr.com/polygon_mumbai",
    symbol: "MATIC",
    blockExplorerUrl: "https://mumbai.polygonscan.com/",
  ),
  ChainEnum.solana: ChainConfigBean(
    name: "Solana",
    caip2Id: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
    rpcUrl:
        "https://solana-mainnet.g.alchemy.com/v2/OcDDIITk_cjAm4V5ZgeD5bcCiHr-Uduc/",
    symbol: "SOL",
    blockExplorerUrl: "https://explorer.solana.com/",
  ),
  ChainEnum.solanatestnet: ChainConfigBean(
    name: "Solana Testnet",
    caip2Id: "solana:8E9rvCKLFQia2Y35HXjjpWzj8weVo44K",
    rpcUrl: "https://api.devnet.solana.com",
    symbol: "SOL",
    blockExplorerUrl: "https://explorer.solana.com/",
  ),
  ChainEnum.starknettestnet: ChainConfigBean(
    name: "StarkNet Testnet",
    caip2Id: "starknet:SN_GOERLI",
    rpcUrl: "https://starknet-testnet-rpc.elara.patract.io",
    symbol: "ETH",
    blockExplorerUrl: "https://explorer.starknet.io/",
  ),
  ChainEnum.tron: ChainConfigBean(
    name: "Tron",
    caip2Id: "unknow:0",
    rpcUrl: "http://47.95.206.44:50545/jsonrpc",
    symbol: "TRX",
    blockExplorerUrl: "https://tronscan.org/",
  )
};

ChainEnum? chainEnumByCaip2Semantics(String value) {
  for (var entry in caip2Map.entries) {
    if (entry.value.caip2Id == value) {
      return entry.key;
    }
  }
  return null; // 如果找不到匹配的值，返回null或者适当的默认值
}

// # Ethereum mainnet
// eip155:1

// # Bitcoin mainnet (see https://github.com/bitcoin/bips/blob/master/bip-0122.mediawiki#definition-of-chain-id)
// bip122:000000000019d6689c085ae165831e93

// # Litecoin
// bip122:12a765e31ffd4059bada1e25190f6e98

// # Feathercoin (Litecoin fork)
// bip122:fdbe99b90c90bae7505796461471d89a

// # Cosmos Hub (Tendermint + Cosmos SDK)
// cosmos:cosmoshub-2
// cosmos:cosmoshub-3

// # Binance chain (Tendermint + Cosmos SDK; see https://dataseed5.defibit.io/genesis)
// cosmos:Binance-Chain-Tigris

// # IOV Mainnet (Tendermint + weave)
// cosmos:iov-mainnet

// # StarkNet Testnet
// starknet:SN_GOERLI

// # Lisk Mainnet (LIP-0009; see https://github.com/LiskHQ/lips/blob/master/proposals/lip-0009.md)
// lip9:9ee11e9df416b18b

// # Dummy max length (8+1+32 = 41 chars/bytes)
// chainstd:8c3444cf8970a9e41a706fab93e7a6c4
