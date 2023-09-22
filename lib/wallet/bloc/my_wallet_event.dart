part of 'my_wallet_bloc.dart';

@immutable
abstract class MyWalletEvent extends Equatable {
  const MyWalletEvent();
}

class TronWalletUpdated extends MyWalletEvent {
  const TronWalletUpdated({required this.tronAddress});

  final String tronAddress;

  @override
  List<Object?> get props => [tronAddress];
}

class BitcoinWalletUpdated extends MyWalletEvent {
  const BitcoinWalletUpdated({required this.bitcoinAddress});

  final String bitcoinAddress;

  @override
  List<Object?> get props => [bitcoinAddress];
}

class BitcoinBech32WalletUpdated extends MyWalletEvent {
  const BitcoinBech32WalletUpdated({required this.bitcoinBech32Address});

  final String bitcoinBech32Address;

  @override
  List<Object?> get props => [bitcoinBech32Address];
}

class EthereumWalletUpdated extends MyWalletEvent {
  const EthereumWalletUpdated({required this.ethereumAddress});

  final String ethereumAddress;

  @override
  List<Object?> get props => [ethereumAddress];
}
