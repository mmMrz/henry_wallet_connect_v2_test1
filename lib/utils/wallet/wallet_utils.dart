import 'package:QRTest_v2_test1/utils/logger_utils.dart';
import 'package:wallet/wallet.dart' as wallet;

import 'chain_enum.dart';

const mnemonicStr = "later,miss,mobile,under,canal,simple,vast,ladder,clinic,arrest,guess,exhaust";

class WalletUtils {
  static WalletUtils? _instance;
  factory WalletUtils.getInstance() {
    // 如果实例尚未创建，创建一个新实例
    _instance ??= WalletUtils._();
    return _instance!;
  }

  late wallet.PrivateKey privateKey;

  WalletUtils._() {
    List<String> mnemonic = mnemonicStr.split(",");
    const passphrase = '';

    final seed = wallet.mnemonicToSeed(mnemonic, passphrase: passphrase);
    final master = wallet.ExtendedPrivateKey.master(seed, wallet.xprv);
    final root = master.forPath("m/44'/195'/0'/0/0");
    privateKey = wallet.PrivateKey((root as wallet.ExtendedPrivateKey).key);
  }

  getPrivateKey() {
    return privateKey;
  }

  wallet.PublicKey getPublicKey(ChainEnum chainEnum) {
    wallet.PublicKey publicKey;
    switch (chainEnum) {
      case ChainEnum.bitcoin:
        publicKey = wallet.bitcoin.createPublicKey(privateKey);
        break;
      case ChainEnum.bitcoinbech32:
        publicKey = wallet.bitcoinbech32.createPublicKey(privateKey);
        break;
      case ChainEnum.ethereum:
        publicKey = wallet.ethereum.createPublicKey(privateKey);
        break;
      case ChainEnum.tron:
        publicKey = wallet.tron.createPublicKey(privateKey);
        break;
      default:
        publicKey = wallet.bitcoin.createPublicKey(privateKey);
    }
    return publicKey;
  }

  String getAddress(ChainEnum chainEnum, wallet.PublicKey publicKey) {
    String address;
    switch (chainEnum) {
      case ChainEnum.bitcoin:
        address = wallet.bitcoin.createAddress(publicKey);
        break;
      case ChainEnum.bitcoinbech32:
        address = wallet.bitcoinbech32.createAddress(publicKey);
        break;
      case ChainEnum.ethereum:
        address = wallet.ethereum.createAddress(publicKey);
        break;
      case ChainEnum.tron:
        address = wallet.tron.createAddress(publicKey);
        break;
      default:
        address = wallet.bitcoin.createAddress(publicKey);
    }
    return address;
  }
}
