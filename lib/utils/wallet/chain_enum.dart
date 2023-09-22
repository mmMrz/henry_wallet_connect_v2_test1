enum ChainEnum {
  tron,
  ethereum,
  bnbsmartchain,
  bitcoin,
  bitcoinbech32,
  litecoin,
  feathercoin,
  cosmos,
  binancechain,
  iovmainnet,
  starknettestnet,
  liskmainnet,
  solana,
  dummy,
}

// CAIP2 semantics
// https://github.com/ChainAgnostic/CAIPs/blob/main/CAIPs/caip-2.md
Map<ChainEnum, String> caip2Map = {
  ChainEnum.ethereum: "eip155:1",
  ChainEnum.bnbsmartchain: "eip155:56",
  ChainEnum.bitcoin: "bip122:000000000019d6689c085ae165831e93",
  ChainEnum.bitcoinbech32: "unknow:0",
  ChainEnum.tron: "unknow:0",
  ChainEnum.solana: "unknow:0",
  ChainEnum.iovmainnet: "cosmos:iov-mainnet",
  ChainEnum.cosmos: "cosmos:cosmoshub-3",
  ChainEnum.binancechain: "cosmos:Binance-Chain-Tigris",
  ChainEnum.starknettestnet: "starknet:SN_GOERLI",
  ChainEnum.liskmainnet: "lip9:9ee11e9df416b18b",
  ChainEnum.litecoin: "bip122:12a765e31ffd4059bada1e25190f6e98",
  ChainEnum.dummy: "chainstd:8c3444cf8970a9e41a706fab93e7a6c4",
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