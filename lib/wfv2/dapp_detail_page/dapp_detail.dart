import 'package:QRTest_v2_test1/wfv2/dapp_detail_page/bloc/dapp_detail_bloc.dart';
import 'package:QRTest_v2_test1/widget/button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class DappDetailPage extends StatelessWidget {
  const DappDetailPage({super.key, required this.sessionData});

  final SessionData sessionData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletConnect Demo'),
      ),
      body: BlocProvider(
        create: (_) {
          DappDetailBloc bloc = DappDetailBloc();

          return bloc;
        },
        lazy: false,
        child: DappDetailView(sessionData: sessionData),
      ),
    );
  }
}

class DappDetailView extends StatelessWidget {
  const DappDetailView({super.key, required this.sessionData});

  final SessionData sessionData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            width: 54,
            height: 54,
            imageUrl: sessionData.peer.metadata.icons.first,
            placeholder: (context, url) => const Center(
              child: SizedBox(
                width: 54,
                height: 54,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Text(sessionData.peer.metadata.name),
          Text(sessionData.peer.metadata.url),
          Text(sessionData.peer.metadata.description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(width: double.infinity, child: Text("Topic:", style: TextStyle(fontWeight: FontWeight.bold))),
          Text(sessionData.topic, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: double.infinity, child: Text("PairingTopic:")),
          Text(sessionData.pairingTopic, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: double.infinity, child: Text("Value:")),
          ExpandableText(sessionData.toString(), expandText: "show more", collapseText: "show less", maxLines: 2),
          const SizedBox(height: 30),
          normalButton("Disonnect", () {
            BlocProvider.of<DappDetailBloc>(context).disconnect(sessionData.topic);
            Navigator.of(context).pop("refresh");
          }, color: Colors.blueGrey),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
