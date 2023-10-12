// Package imports:
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WFV2Client {
  static WFV2Client? _instance;
  factory WFV2Client.getInstance() {
    // 如果实例尚未创建，创建一个新实例
    _instance ??= WFV2Client._();
    return _instance!;
  }

  late Web3Wallet wcClient;

  WFV2Client._() {}

  init() async {
    wcClient = await Web3Wallet.createInstance(
      projectId: '602617b1157a2c68b1afc1b97d6ffd45',
      metadata: const PairingMetadata(
        name: 'MetaMask',
        description: 'Henry Wallet Connect V2 Test 1',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );
  }
}
