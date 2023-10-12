// Dart imports:

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:QRTest_v2_test1/utils/wallet/chain_enum.dart';
import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';

part 'my_wallet_event.dart';
part 'my_wallet_state.dart';

class MyWalletBloc extends Bloc<MyWalletEvent, MyWalletState> {
  MyWalletBloc()
      : super(const MyWalletState(
            solanaAddress: null,
            tronAddress: null,
            bitcoinAddress: null,
            bitcoinBech32Address: null,
            ethereumAddress: null)) {
    on<MyWalletEvent>((event, emit) {
      if (event is TronWalletUpdated) {
        emit(state.copyWith(tronAddress: event.tronAddress));
      } else if (event is BitcoinWalletUpdated) {
        emit(state.copyWith(bitcoinAddress: event.bitcoinAddress));
      } else if (event is BitcoinBech32WalletUpdated) {
        emit(state.copyWith(bitcoinBech32Address: event.bitcoinBech32Address));
      } else if (event is EthereumWalletUpdated) {
        emit(state.copyWith(ethereumAddress: event.ethereumAddress));
      } else if (event is SolanaWalletUpdated) {
        emit(state.copyWith(solanaAddress: event.solanaAddress));
      }
    });
  }

  loadBitcoinWallet() async {
    //不知道为什么，这里必须要用一个协程来执行，不然会造成堵塞，Future也不行，这个问题待研究.

    final WalletUtils walletUtils = WalletUtils.getInstance();
    final String bitcoinAddress = walletUtils.getAddress(ChainEnum.bitcoin);
    add(BitcoinWalletUpdated(bitcoinAddress: bitcoinAddress));
  }

  loadBitcoinBech32Wallet() {
    final WalletUtils walletUtils = WalletUtils.getInstance();
    final String bitcoinBech32Address =
        walletUtils.getAddress(ChainEnum.bitcoinbech32);
    add(BitcoinBech32WalletUpdated(bitcoinBech32Address: bitcoinBech32Address));
  }

  loadEthereumWallet() {
    final WalletUtils walletUtils = WalletUtils.getInstance();
    final String ethereumAddress = walletUtils.getAddress(ChainEnum.ethereum);
    add(EthereumWalletUpdated(ethereumAddress: ethereumAddress));
  }

  loadTronWallet() {
    final WalletUtils walletUtils = WalletUtils.getInstance();
    final String tronAddress = walletUtils.getAddress(ChainEnum.tron);
    add(TronWalletUpdated(tronAddress: tronAddress));
  }

  loadSolanaWallet() {
    final WalletUtils walletUtils = WalletUtils.getInstance();
    final String solanaAddress = walletUtils.getAddress(ChainEnum.solana);
    add(SolanaWalletUpdated(solanaAddress: solanaAddress));
  }
}
