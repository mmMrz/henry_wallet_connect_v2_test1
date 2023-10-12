part of 'my_wallet_bloc.dart';

@immutable
class MyWalletState extends Equatable {
  const MyWalletState(
      {required this.cosmosAddress,
      required this.solanaAddress,
      required this.tronAddress,
      required this.bitcoinAddress,
      required this.bitcoinBech32Address,
      required this.ethereumAddress});

  final String? cosmosAddress, solanaAddress, tronAddress, bitcoinAddress, bitcoinBech32Address, ethereumAddress;

  @override
  List<Object?> get props => [cosmosAddress, solanaAddress, tronAddress, bitcoinAddress, bitcoinBech32Address, ethereumAddress];

  MyWalletState copyWith({
    String? cosmosAddress,
    String? solanaAddress,
    String? tronAddress,
    String? bitcoinAddress,
    String? bitcoinBech32Address,
    String? ethereumAddress,
  }) {
    return MyWalletState(
      cosmosAddress: cosmosAddress ?? this.cosmosAddress,
      solanaAddress: solanaAddress ?? this.solanaAddress,
      tronAddress: tronAddress ?? this.tronAddress,
      bitcoinAddress: bitcoinAddress ?? this.bitcoinAddress,
      bitcoinBech32Address: bitcoinBech32Address ?? this.bitcoinBech32Address,
      ethereumAddress: ethereumAddress ?? this.ethereumAddress,
    );
  }
}
