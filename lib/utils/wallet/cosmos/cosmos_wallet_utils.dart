import "package:alan/alan.dart";
import 'package:alan/proto/cosmos/auth/v1beta1/export.dart' as auth;
import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;
import 'package:alan/proto/cosmos/slashing/v1beta1/export.dart' as slashing;
import 'package:alan/proto/cosmos/crisis/v1beta1/export.dart' as crisis;
import 'package:alan/proto/cosmos/distribution/v1beta1/export.dart' as distr;
import 'package:alan/proto/cosmos/gov/v1beta1/export.dart' as gov;
import 'package:alan/proto/cosmos/mint/v1beta1/export.dart' as mint;
import 'package:alan/proto/cosmos/params/v1beta1/export.dart' as params;
import 'package:alan/proto/cosmos/slashing/v1beta1/export.dart' as slashing;
import 'package:alan/proto/cosmos/staking/v1beta1/export.dart' as staking;
import 'package:alan/proto/cosmos/upgrade/v1beta1/export.dart' as upgrade;

final networkInfo = NetworkInfo.fromSingleHost(
  bech32Hrp: "cosmos",
  host: "https://cosmos-mainnet-rpc.allthatnode.com:26657",
);

final mnemonic = [
  "nothing",
  "steak",
  "step",
  "patient",
  "peasant",
  "assist",
  "add",
  "coral",
  "tone",
  "harsh",
  "hint",
  "dilemma",
];
final cosmosWallet = Wallet.derive(
  mnemonic,
  networkInfo,
  derivationPath: "m/44'/118'/0'/0/0", // Optional - Default m/44'/118'/0'/0/0
);

Future<String?> signMessage(String message) async {
  // Create your message
  final message = bank.MsgSend.create()
    ..fromAddress = cosmosWallet.bech32Address
    ..toAddress = 'cosmos1cx7mec8x567xh8f4x7490ndx7xey8lnr9du2qy';
  message.amount.add(
    Coin.create()
      ..denom = 'uatom'
      ..amount = '100',
  );

  // Compose the transaction fees
  final fee = Fee();
  fee.gasLimit = 200000.toInt64();
  fee.amount.add(
    Coin.create()
      ..amount = '100'
      ..denom = 'uatom',
  );

  // Build the signer
  final signer = TxSigner.fromNetworkInfo(networkInfo);

  // Create and sign the transaction
  final signedTx = await signer.createAndSign(
    cosmosWallet,
    [message],
    memo: 'Optional memo', // Optional
    fee: fee, // Optional (Default is 200000 gas and empty amount)
  );
  return signedTx.toString();
}
