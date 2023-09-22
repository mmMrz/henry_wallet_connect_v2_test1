import 'dart:typed_data';

import 'package:QRTest_v2_test1/utils/logger_utils.dart';
import 'package:QRTest_v2_test1/utils/wallet/chain_enum.dart';
import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';
import 'package:QRTest_v2_test1/wfv2/bloc/wf_home_bloc.dart';
import 'package:QRTest_v2_test1/wfv2/dapp_detail_page/dapp_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:QRTest_v2_test1/widget/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WFHomePage extends StatelessWidget {
  const WFHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletConnect Demo'),
      ),
      body: BlocProvider(
        create: (_) {
          WfHomeBloc bloc = WfHomeBloc();

          return bloc;
        },
        lazy: false,
        child: const WFHomeView(),
      ),
    );
  }
}

class WFHomeView extends StatelessWidget {
  const WFHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WfHomeBloc bloc = BlocProvider.of(context);
    return BlocListener<WfHomeBloc, WfHomeState>(
      listener: (context, state) {
        //NDialog是一个三方库，来自于pub.dev
        if (state is NoPermissionState) {
          Dialogs.materialDialog(msg: 'You has been denied the camera, please granted it', title: "No permission", color: Colors.white, context: context, actions: [
            normalButton("Cancel", color: Colors.blueGrey, () {
              Navigator.of(context).pop();
            }),
            normalButton("Settings", () {
              openAppSettings();
            })
          ]);
        } else if (state is WfHomeSessionProposalState) {
          NDialog(
            dialogStyle: DialogStyle(titleDivider: true),
            title: const Text(
              "Session Proposal",
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: 200,
              height: 200,
              child: SingleChildScrollView(child: Text(state.args!.params.toString())),
            ),
            actions: <Widget>[
              normalButton("Cancel", () {
                bloc.rejectSession(state.args!.id);
                Navigator.of(context).pop();
              }, color: Colors.blueGrey),
              normalButton("Connect", () {
                bloc.approveSession(state.args!.id, state.args!.params);
                Navigator.of(context).pop();
              }),
            ],
          ).show(context);
        }
      },
      child: BlocBuilder<WfHomeBloc, WfHomeState>(
        builder: (context, state) {
          if (state.activeSessions != null && state.activeSessions!.isNotEmpty) {
            return ListView.builder(
              itemCount: state.activeSessions!.length,
              itemBuilder: (BuildContext context, int index) {
                String key = state.activeSessions!.keys.elementAt(index);
                SessionData value = state.activeSessions![key]!;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DappDetailPage(sessionData: value)));
                  },
                  child: ListTile(
                    leading: CachedNetworkImage(
                      width: 54,
                      height: 54,
                      imageUrl: value.peer.metadata.icons.first,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 54,
                          height: 54,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text('DAPP: ${value.peer.metadata.name}'),
                    subtitle: Text('Topic: $key', style: const TextStyle(fontSize: 13)),
                  ),
                );
              },
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'WalletConnect Demo',
                ),
                normalButton("ScanQR", () {
                  bloc.scanQR();
                }, width: 200),
                state.wcUri?.isNotEmpty ?? false ? Text(state.wcUri!) : const SizedBox(),
                state.wcUri?.isNotEmpty ?? false
                    ? normalButton("Connect", () {
                        bloc.connect(state.wcUri!);
                      }, width: 200)
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:eth_sig_util/eth_sig_util.dart';

// String signature = EthSigUtil.signTypedData(privateKey: '4af...bb0', jsonData: '{...}', version: TypedDataVersion.V4);

// String signature = EthSigUtil.signPersonalTypedData(privateKey: '4af...bb0', jsonData: '{...}', version: TypedDataVersion.V4);

// String signature = EthSigUtil.signMessage(privateKey: '4af...bb0', message: []);

// String signature = EthSigUtil.signPersonalMessage(privateKey: '4af...bb0', message: []);

// String address = EthSigUtil.recoverSignature(signature: '0x84ea3...', message: []);

// String address = EthSigUtil.recoverPersonalSignature(signature: '0x84ea3...', message: []);