// Dart imports:

// Package imports:
import 'package:QRTest_v2_test1/entity/solana_sign_message/solana_sign_message.dart';
import 'package:QRTest_v2_test1/entity/solana_sign_transaction/solana_sign_transaction.dart';
import 'package:QRTest_v2_test1/utils/number_utils.dart';
import 'package:solana/base58.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

// Project imports:
import 'package:QRTest_v2_test1/entity/solana_sign_transaction/solana_sign_transaction.dart';
import 'package:QRTest_v2_test1/utils/number_utils.dart';

class SolanaWalletUtils {
  static SolanaWalletUtils? _instance;
  factory SolanaWalletUtils.getInstance() {
    // 如果实例尚未创建，创建一个新实例
    _instance ??= SolanaWalletUtils._();
    return _instance!;
  }

  Ed25519HDKeyPair? source;
  SolanaWalletUtils._() {
    init();
  }

  init() async {
    source = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
  }

  final String mnemonic = 'nothing steak step patient peasant assist add coral tone harsh hint dilemma';

  final SolanaClient solanaClient =
      SolanaClient(rpcUrl: Uri.parse("https://api.devnet.solana.com"), websocketUrl: Uri.parse("wss://api.devnet.solana.com"));

  String getPrivateKey() {
    return source.toString();
  }

  String? getPublicKey() {
    return source?.publicKey.toBase58();
  }

  String? getAddress() {
    return source?.address;
  }

  Future<String?> signMessage(SolanaSignMessage solanaSignMessage) async {
// MemoInstruction/TokenInstruction/StakeInstruction

    // final message = Message.only(MemoInstruction(signers: [Ed25519HDPublicKey.fromBase58(solanaSignMessage.pubkey)], memo: solanaSignMessage.message));
    // // final message = Message.only(TokenInstruction())

    // final recentBlockhash = (await solanaClient.rpcClient.getLatestBlockhash(commitment: Commitment.confirmed)).value;
//X3CUgCGzyn43DTAbUKnTMDzcGWMooJT2hPSZinjfN1QUgVNYYfeoJ5zg6i4MYqYWB9kSiyHjTQA
// DEqAF7ZP6n1aZBnxyGHfbbZR4bFxH3wmKJC8JhuVGYVZ

    final sign = await source?.sign(base58decode(solanaSignMessage.message));
    if (sign == null) {
      return null;
    }
    String signature = base58encode(sign.bytes);
    return signature;
    // final instruction = SystemInstruction.transfer(
    //   fundingAccount: source!.publicKey,
    //   recipientAccount: source!.publicKey,
    //   lamports: 1000000,
    // );

    // final message = Message.only(instruction);

    // final compiledMessage = message.compileV0(
    //   recentBlockhash: recentBlockhash.blockhash,
    //   feePayer: source!.publicKey,
    // );

    // final sign = await source?.signMessage(message: message, recentBlockhash: recentBlockhash.blockhash);
    // if (sign == null) {
    //   return null;
    // }
    // String signature = sign.signatures.first.toBase58();
    // return signature;
  }

  Future<String?> signTransaction(SolanaSignTransaction solanaSignTransaction) async {
    // final compiledMessage = await getCompiledTransfersMessage(
    //   precision,
    //   amount,
    //   fromAddress,
    //   toAddress,
    //   contractAddress: contractAddress,
    // );

    List<Instruction> instructions = List.empty(growable: true);
    for (var element in solanaSignTransaction.instructions) {
      List<AccountMeta> accountMetas = [];
      for (var key in element.keys) {
        accountMetas.add(AccountMeta.writeable(pubKey: Ed25519HDPublicKey.fromBase58(key.pubkey), isSigner: key.isSigner));
      }
      instructions
          .add(Instruction(programId: Ed25519HDPublicKey.fromBase58(element.programId), accounts: accountMetas, data: ByteArray(element.data)));
    }

    Message message = Message.only(instructions.first);
    // CompiledMessage compiledMessage = message.compile(recentBlockhash: solanaSignTransaction.recentBlockhash, feePayer: Ed25519HDPublicKey.fromBase58(solanaSignTransaction.feePayer));

    //====

    // final recentBlockhash = await client.rpcClient.getRecentBlockhash(commitment: Commitment.confirmed).value;
    // final instruction = SystemInstruction.transfer(
    //   fundingAccount: source.publicKey,
    //   recipientAccount: destination.publicKey,
    //   lamports: _transferredAmount,
    // );

    // final message = Message.only(instruction);

    // final compiledMessage = message.compileV0(
    //   recentBlockhash: recentBlockhash.blockhash,
    //   feePayer: source.publicKey,
    // );
    //CompiledMessage到这里为止取到了
// source?.signMessage(message: message, recentBlockhash: recentBlockhash)

    final sign = await source?.signMessage(message: message, recentBlockhash: solanaSignTransaction.recentBlockhash);
    if (sign == null) {
      return null;
    }
    String signature = sign.signatures.first.toBase58();
    return signature;

    // final sign = await source?.sign(compiledMessage.toByteArray());
    // if (sign == null) {
    //   return null;
    // }
    // final pubkeyBytes = source?.publicKey.bytes;
    // final sigBytes = sign.bytes;
    // final tx = SignedTx(compiledMessage: compiledMessage, signatures: [
    //   cryptography.Signature(
    //     sigBytes,
    //     publicKey: cryptography.SimplePublicKey(pubkeyBytes!, type: cryptography.KeyPairType.ed25519),
    //   ),
    // ]);
    // return base58encode(tx.toByteArray().toList());

    // final SignedTx signedTx = SignedTx(
    //   signatures: [sign],
    //   compiledMessage: compiledMessage,
    // );
    // String signature = signedTx.signatures.first.toBase58();
    // if (signature.isNotEmpty) {
    //   log.d("交易完成的HASH:$signature");
    //   return signature;
    // }
    // return null;

    // final String signature = await solanaClient.rpcClient.sendTransaction(
    //   signedTx.encode(),
    //   preflightCommitment: Commitment.confirmed,
    // );
    // expect(signature, signedTx.signatures.first.toBase58());

    //====

    // ChainEnum chainBean = ChainConfigUtils.getChainEnumWithClassName(className());
    // MethodCallbackBean result = await nativeUtils.getSignedTX(chainEnum: chainBean, trueBippath: fromAsset.isLegacy, argument: {
    //   "bipIndex": fromAsset.bipIndex,
    //   "hash": HexUtils.uint8ToHex(Uint8List.fromList(compiledMessage.data.toList())),
    // });

    // if (result.code == 0) {
    //   return null;
    // }

    // final pubkeyBytes = HexUtils.hexToListInt(fromAsset.publicKey);
    // final sigBytes = HexUtils.hexToListInt(result.result);
    // final tx = SignedTx(messageBytes: compiledMessage.data, signatures: [
    //   new cryptography.Signature(
    //     sigBytes,
    //     publicKey: cryptography.SimplePublicKey(pubkeyBytes, type: cryptography.KeyPairType.ed25519),
    //   ),
    // ]);

    // String hash = await solRPCProxy.sendRawTransaction(tx.encode());

    // if (hash != null) {
    //   print("交易完成的HASH:" + hash);
    //   return hash;
    // }
    // return null;
  }

  Future<CompiledMessage> getCompiledTransfersMessage(
    int precision,
    String amount,
    String fromAddress,
    String toAddress, {
    String? contractAddress,
  }) async {
    final fromPublicKey = Ed25519HDPublicKey.fromBase58(fromAddress);
    final toPublicKey = Ed25519HDPublicKey.fromBase58(toAddress);

    final latestBlockhash = await solanaClient.rpcClient.getLatestBlockhash();

    List<Instruction> instructions;

    if (contractAddress == null) {
      instructions = [
        SystemInstruction.transfer(
          fundingAccount: fromPublicKey,
          recipientAccount: toPublicKey,
          lamports: NumberUtils.removePrecision(amount, precision).toInt(),
        )
      ];
    } else {
      final mintPublicKey = Ed25519HDPublicKey.fromBase58(contractAddress);
      final fromAssociatedTokenAddress = await findAssociatedTokenAddress(owner: fromPublicKey, mint: mintPublicKey);
      final toAssociatedTokenAddress = await findAssociatedTokenAddress(owner: toPublicKey, mint: mintPublicKey);

      final tokenInstruction = TokenInstruction.transferChecked(
          amount: NumberUtils.removePrecision(amount, precision).toInt(),
          decimals: precision,
          source: fromAssociatedTokenAddress,
          mint: mintPublicKey,
          destination: toAssociatedTokenAddress,
          owner: fromPublicKey);

      final isAccountExist = await checkAccountIsExist(toAddress, contractAddress);
      if (isAccountExist) {
        instructions = [tokenInstruction];
      } else {
        final associatedTokenAccountInstruction = AssociatedTokenAccountInstruction.createAccount(
            funder: fromPublicKey, address: toAssociatedTokenAddress, owner: toPublicKey, mint: mintPublicKey);
        instructions = [associatedTokenAccountInstruction, tokenInstruction];
      }
    }
    Message message = Message(instructions: instructions);
    final compiledMessage = message.compile(recentBlockhash: latestBlockhash.value.blockhash, feePayer: fromPublicKey);

    return compiledMessage;
  }

  Future<bool> checkAccountIsExist(String address, String contractAddress) async {
    final toAssociatedTokenAddress =
        await findAssociatedTokenAddress(owner: Ed25519HDPublicKey.fromBase58(address), mint: Ed25519HDPublicKey.fromBase58(contractAddress));
    final toAssociatedTokenAccountInfo = await solanaClient.rpcClient.getAccountInfo(toAssociatedTokenAddress.toBase58());
    if (toAssociatedTokenAccountInfo.value == null) {
      return false;
    }
    return true;
  }
}
