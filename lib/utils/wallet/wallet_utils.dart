import 'dart:math';
import 'dart:typed_data';

import 'package:QRTest_v2_test1/utils/logger_utils.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
// import 'package:wallet/wallet.dart' as wallet;

import 'chain_enum.dart';

const mnemonicStr = "later,miss,mobile,under,canal,simple,vast,ladder,clinic,arrest,guess,exhaust";

class WalletUtils {
  static WalletUtils? _instance;
  factory WalletUtils.getInstance() {
    // 如果实例尚未创建，创建一个新实例
    _instance ??= WalletUtils._();
    return _instance!;
  }

  late EthPrivateKey credentials;

  WalletUtils._() {
    credentials = EthPrivateKey.fromHex("300851edb635b2dbb2d4e70615444925afeb60bf95c19365aff88740e09d7345");

    // In either way, the library can derive the public key and the address
    // from a private key:
    var address = credentials.address;

    log.d(address.hex);
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
      default:
        address = credentials.address.hex;
    }
    return address;
  }
}
