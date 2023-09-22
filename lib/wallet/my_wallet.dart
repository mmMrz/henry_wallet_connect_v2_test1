import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';
import 'package:QRTest_v2_test1/wallet/bloc/my_wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              );
            },
          ),
          const Text(
            'Ethereum Address',
          ),
          BlocBuilder<MyWalletBloc, MyWalletState>(
            builder: (context, state) {
              return Text(
                state.ethereumAddress ?? 'Loading...',
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
              );
            },
          ),
        ],
      ),
    );
  }
}
