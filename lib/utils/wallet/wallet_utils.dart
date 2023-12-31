// Dart imports:

// Package imports:
import 'package:QRTest_v2_test1/utils/logger_utils.dart';
import 'package:QRTest_v2_test1/utils/wallet/cosmos/cosmos_wallet_utils.dart';
import 'package:QRTest_v2_test1/utils/wallet/solana/solana_wallet_utils.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

// Project imports:
import 'chain_enum.dart';

// import 'package:wallet/wallet.dart' as wallet;

// const mnemonicStr = "later,miss,mobile,under,canal,simple,vast,ladder,clinic,arrest,guess,exhaust";

class WalletUtils {
  static WalletUtils? _instance;
  factory WalletUtils.getInstance() {
    // 如果实例尚未创建，创建一个新实例
    _instance ??= WalletUtils._();
    return _instance!;
  }
  String test = "test";

  late EthPrivateKey credentials;
  late SolanaWalletUtils solanaWalletUtils;

  WalletUtils._() {
    solanaWalletUtils = SolanaWalletUtils.getInstance();

    //0x901982861c8fe2e5313d2853e5519bf018711233
    credentials = EthPrivateKey.fromHex("00925d1cab29f94baa902c623ee5463d6c256439cde19aef4ae790aae9bf312510");
    var address = credentials.address;
    log.d("初始化Evm3Wallet地址:${address.hex}");
  }

  String getPrivateKey() {
    return bytesToHex(credentials.privateKey);
  }

  String getPublicKey(ChainEnum chainEnum) {
    String publicKey;
    switch (chainEnum) {
      case ChainEnum.bitcoin:
        publicKey = "wallet.bitcoin.createPublicKey(privateKey)";
        break;
      case ChainEnum.bitcoinbech32:
        publicKey = "wallet.bitcoinbech32.createPublicKey(privateKey)";
        break;
      case ChainEnum.arbitrum:
      case ChainEnum.arbitrumgoerli:
      case ChainEnum.arbitrumrinkeby:
      case ChainEnum.avalanchecchain:
      case ChainEnum.avalanchecchaintestnet:
      case ChainEnum.bnbsmartchain:
      case ChainEnum.bnbsmartchaintestnet:
      case ChainEnum.binancechain:
      case ChainEnum.bitkubchain:
      case ChainEnum.bitkubchaintestnet:
      case ChainEnum.celo:
      case ChainEnum.celotestnet:
      case ChainEnum.cronos:
      case ChainEnum.cronostestnet:
      case ChainEnum.ethereum:
      case ChainEnum.ethereumsepolia:
      case ChainEnum.ethereumgoerli:
      case ChainEnum.ethereumclassic:
      case ChainEnum.ethereumclassictestnet:
      case ChainEnum.filecoin:
      case ChainEnum.filecointestnet:
      case ChainEnum.okc:
      case ChainEnum.okctestnet:
      case ChainEnum.polygon:
      case ChainEnum.polygonmumbai:
        publicKey = bytesToHex(credentials.encodedPublicKey);
        break;
      case ChainEnum.tron:
        publicKey = "wallet.tron.createPublicKey(privateKey)";
        break;
      case ChainEnum.solana:
      case ChainEnum.solanatestnet:
        publicKey = solanaWalletUtils.getPublicKey() ?? "please retry";
        break;
      case ChainEnum.cosmos:
      case ChainEnum.cosmostheta:
        publicKey = cosmosWallet.ecPublicKey.toString();
        break;
      default:
        publicKey = bytesToHex(credentials.encodedPublicKey);
    }
    return publicKey;
  }

  String getAddress(ChainEnum chainEnum) {
    String address;
    switch (chainEnum) {
      case ChainEnum.bitcoin:
        address = "wallet.bitcoin.createAddress(publicKey)";
        break;
      case ChainEnum.bitcoinbech32:
        address = "wallet.bitcoinbech32.createAddress(publicKey)";
        break;
      case ChainEnum.arbitrum:
      case ChainEnum.arbitrumgoerli:
      case ChainEnum.arbitrumrinkeby:
      case ChainEnum.avalanchecchain:
      case ChainEnum.avalanchecchaintestnet:
      case ChainEnum.bnbsmartchain:
      case ChainEnum.bnbsmartchaintestnet:
      case ChainEnum.binancechain:
      case ChainEnum.bitkubchain:
      case ChainEnum.bitkubchaintestnet:
      case ChainEnum.celo:
      case ChainEnum.celotestnet:
      case ChainEnum.cronos:
      case ChainEnum.cronostestnet:
      case ChainEnum.ethereum:
      case ChainEnum.ethereumsepolia:
      case ChainEnum.ethereumgoerli:
      case ChainEnum.ethereumclassic:
      case ChainEnum.ethereumclassictestnet:
      case ChainEnum.filecoin:
      case ChainEnum.filecointestnet:
      case ChainEnum.okc:
      case ChainEnum.okctestnet:
      case ChainEnum.polygon:
      case ChainEnum.polygonmumbai:
        address = credentials.address.hex;
        break;
      case ChainEnum.tron:
        address = "wallet.tron.createAddress(publicKey)";
        break;
      case ChainEnum.solana:
      case ChainEnum.solanatestnet:
        address = solanaWalletUtils.getAddress() ?? "please retry";
        if (address == "please retry") {
          address = solanaWalletUtils.getAddress() ?? "please retry";
        }
        break;
      case ChainEnum.cosmos:
      case ChainEnum.cosmostheta:
        address = cosmosWallet.bech32Address;
        break;
      default:
        address = credentials.address.hex;
    }
    return address;
  }
}
