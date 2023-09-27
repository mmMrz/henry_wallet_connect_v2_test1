import 'dart:isolate';

import 'package:QRTest_v2_test1/utils/wallet/chain_enum.dart';
import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wallet/wallet.dart';

part 'my_wallet_event.dart';
part 'my_wallet_state.dart';

class MyWalletBloc extends Bloc<MyWalletEvent, MyWalletState> {
  MyWalletBloc() : super(const MyWalletState(tronAddress: null, bitcoinAddress: null, bitcoinBech32Address: null, ethereumAddress: null)) {
    on<MyWalletEvent>((event, emit) {
      if (event is TronWalletUpdated) {
        emit(state.copyWith(tronAddress: event.tronAddress));
      } else if (event is BitcoinWalletUpdated) {
        emit(state.copyWith(bitcoinAddress: event.bitcoinAddress));
      } else if (event is BitcoinBech32WalletUpdated) {
        emit(state.copyWith(bitcoinBech32Address: event.bitcoinBech32Address));
      } else if (event is EthereumWalletUpdated) {
        emit(state.copyWith(ethereumAddress: event.ethereumAddress));
      }
    });
  }

  loadBitcoinWallet() async {
    //不知道为什么，这里必须要用一个协程来执行，不然会造成堵塞，Future也不行，这个问题待研究.
    void runTaskInIsolate(SendPort sendPort) {
      final WalletUtils walletUtils = WalletUtils.getInstance();
      final String bitcoinAddress = walletUtils.getAddress(ChainEnum.bitcoin);
      sendPort.send(bitcoinAddress);
    }

    ReceivePort mainReceivePort = ReceivePort();
    mainReceivePort.listen((message) {
      if (message is String) {
        add(BitcoinWalletUpdated(bitcoinAddress: message));
      }
    });
    Isolate.spawn(runTaskInIsolate, mainReceivePort.sendPort);
  }

  loadBitcoinBech32Wallet() {
    void runTaskInIsolate(SendPort sendPort) {
      final WalletUtils walletUtils = WalletUtils.getInstance();
      final String bitcoinBech32Address = walletUtils.getAddress(ChainEnum.bitcoinbech32);
      sendPort.send(bitcoinBech32Address);
    }

    ReceivePort mainReceivePort = ReceivePort();
    mainReceivePort.listen((message) {
      if (message is String) {
        add(BitcoinBech32WalletUpdated(bitcoinBech32Address: message));
      }
    });
    Isolate.spawn(runTaskInIsolate, mainReceivePort.sendPort);
  }

  loadEthereumWallet() {
    void runTaskInIsolate(SendPort sendPort) {
      final WalletUtils walletUtils = WalletUtils.getInstance();
      final String ethereumAddress = walletUtils.getAddress(ChainEnum.ethereum);
      sendPort.send(ethereumAddress);
    }

    ReceivePort mainReceivePort = ReceivePort();
    mainReceivePort.listen((message) {
      if (message is String) {
        add(EthereumWalletUpdated(ethereumAddress: message));
      }
    });
    Isolate.spawn(runTaskInIsolate, mainReceivePort.sendPort);
  }

  loadTronWallet() {
    void runTaskInIsolate(SendPort sendPort) {
      final WalletUtils walletUtils = WalletUtils.getInstance();
      final String tronAddress = walletUtils.getAddress(ChainEnum.tron);
      sendPort.send(tronAddress);
    }

    ReceivePort mainReceivePort = ReceivePort();
    mainReceivePort.listen((message) {
      if (message is String) {
        add(TronWalletUpdated(tronAddress: message));
      }
    });
    Isolate.spawn(runTaskInIsolate, mainReceivePort.sendPort);
  }
}
