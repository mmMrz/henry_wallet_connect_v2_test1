// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:QRTest_v2_test1/utils/wallet/chain_enum.dart';
import 'package:QRTest_v2_test1/wallet/bloc/my_wallet_bloc.dart';

class MyWalletPage extends StatelessWidget {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: BlocProvider(
        create: (_) {
          MyWalletBloc bloc = MyWalletBloc();

          final startTime = DateTime.now().millisecondsSinceEpoch;

          // 模拟一些耗时操作
          bloc.loadBitcoinWallet();
          bloc.loadBitcoinBech32Wallet();
          bloc.loadEthereumWallet();
          bloc.loadTronWallet();
          bloc.loadSolanaWallet();

          final endTime = DateTime.now().millisecondsSinceEpoch;
          final difference = endTime - startTime;
          final duration = Duration(milliseconds: difference);

          print("时间戳差值: $duration");

          return bloc;
        },
        lazy: false,
        child: const MyWalletView(),
      ),
    );
  }
}

class MyWalletView extends StatelessWidget {
  const MyWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    String supportedChains = "";
    caip2Map.values.forEach((element) {
      if (element.caip2Id!.startsWith("eip155")) {
        supportedChains += "${element.name},";
      }
    });
    supportedChains += "Solana";
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'My Wallet',
          ),
          const Text(
            'Bitcoin Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.bitcoinAddress ?? 'Loading...',
                style: const TextStyle(color: Colors.green),
              );
            },
          ),
          const Text(
            'BitcoinBech32 Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.bitcoinBech32Address ?? 'Loading...',
                style: const TextStyle(color: Colors.green),
              );
            },
          ),
          const Text(
            'EVM compatible Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.ethereumAddress ?? 'Loading...',
                style: const TextStyle(color: Colors.green),
              );
            },
          ),
          const Text(
            'Tron Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.tronAddress ?? 'Loading...',
                style: const TextStyle(color: Colors.green),
              );
            },
          ),
          const Text(
            'Solana Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.solanaAddress ?? 'Loading...',
                style: const TextStyle(color: Colors.green),
              );
            },
          ),
          const Text(
            'Cosmos Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.cosmosAddress ?? 'Loading...',
                style: const TextStyle(color: Colors.green),
              );
            },
          ),
          const Text("Supported Chains"),
          Text(
            supportedChains,
            style: const TextStyle(color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
