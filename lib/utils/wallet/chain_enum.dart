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
Map<ChainEnum, String> caip2Map = {
  ChainEnum.arbitrum: "eip155:42161",
  ChainEnum.arbitrumgoerli: "eip155:421613",
  ChainEnum.arbitrumrinkeby: "eip155:421611",
  ChainEnum.avalanchecchain: "eip155:43114",
  ChainEnum.avalanchecchaintestnet: "eip155:43113",
  ChainEnum.bnbsmartchain: "eip155:56",
  ChainEnum.bnbsmartchaintestnet: "eip155:97",
  ChainEnum.binancechain: "cosmos:Binance-Chain-Tigris",
  ChainEnum.bitcoin: "bip122:000000000019d6689c085ae165831e93",
  ChainEnum.bitcoinbech32: "unknow:0",
  ChainEnum.bitkubchain: "eip155:96",
  ChainEnum.bitkubchaintestnet: "eip155:25925",
  ChainEnum.celo: "eip155:42220",
  ChainEnum.celotestnet: "eip155:44787",
  ChainEnum.cosmos: "cosmos:cosmoshub-4",
  ChainEnum.cosmostheta: "theta",
  ChainEnum.cronos: "eip155:25",
  ChainEnum.cronostestnet: "eip155:338",
  ChainEnum.dummy: "chainstd:8c3444cf8970a9e41a706fab93e7a6c4",
  ChainEnum.ethereum: "eip155:1",
  ChainEnum.ethereumgoerli: "eip155:5",
  ChainEnum.ethereumsepolia: "eip155:11155111",
  ChainEnum.ethereumclassic: "eip155:61",
  ChainEnum.ethereumclassictestnet: "eip155:63",
  ChainEnum.filecoin: "eip155:314",
  ChainEnum.filecointestnet: "eip155:314159",
  ChainEnum.iovmainnet: "cosmos:iov-mainnet",
  ChainEnum.liskmainnet: "lip9:9ee11e9df416b18b",
  ChainEnum.litecoin: "bip122:12a765e31ffd4059bada1e25190f6e98",
  ChainEnum.okc: "eip155:66",
  ChainEnum.okctestnet: "eip155:65",
  ChainEnum.polygon: "eip155:137",
  ChainEnum.polygonmumbai: "eip155:80001",
  ChainEnum.solana: "solana:4sGjMW1sUnHzSxGspuhpqLDx6wiyjNtZ",
  ChainEnum.solanatestnet: "solana:8E9rvCKLFQia2Y35HXjjpWzj8weVo44K",
  ChainEnum.starknettestnet: "starknet:SN_GOERLI",
  ChainEnum.tron: "unknow:0",
};

ChainEnum? chainEnumByCaip2Semantics(String value) {
  for (var entry in caip2Map.entries) {
    if (entry.value == value) {
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