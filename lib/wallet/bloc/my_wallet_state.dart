part of 'my_wallet_bloc.dart';

@immutable
class MyWalletState extends Equatable {
  const MyWalletState({required this.solanaAddress, required this.tronAddress, required this.bitcoinAddress, required this.bitcoinBech32Address, required this.ethereumAddress});

  final String? solanaAddress, tronAddress, bitcoinAddress, bitcoinBech32Address, ethereumAddress;

  @override
  List<Object?> get props => [solanaAddress, tronAddress, bitcoinAddress, bitcoinBech32Address, ethereumAddress];

  MyWalletState copyWith({
    String? solanaAddress,
    String? tronAddress,
    String? bitcoinAddress,
    String? bitcoinBech32Address,
    String? ethereumAddress,
  }) {
    return MyWalletState(
      solanaAddress: solanaAddress ?? this.solanaAddress,
      tronAddress: tronAddress ?? this.tronAddress,
      bitcoinAddress: bitcoinAddress ?? this.bitcoinAddress,
      bitcoinBech32Address: bitcoinBech32Address ?? this.bitcoinBech32Address,
      ethereumAddress: ethereumAddress ?? this.ethereumAddress,
    );
  }
}
