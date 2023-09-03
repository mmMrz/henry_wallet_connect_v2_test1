import 'dart:typed_data';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:henry_wallet_connect_v2_test1/widget/button.dart';
import 'package:logging/logging.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WFHome extends StatefulWidget {
  const WFHome({super.key});

  @override
  State<WFHome> createState() => _WFHomeState();
}

class _WFHomeState extends State<WFHome> {
  final Logger log = Logger('WFHome');

  @override
  void initState() {
    walletConnect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletConnect Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'WalletConnect Flutter Demo',
            ),
            normalButton("ScanQR", () {
              scanQR();
            }, width: 200),
            wcUri?.isNotEmpty ?? false ? Text(wcUri!) : const SizedBox(),
            wcUri?.isNotEmpty ?? false
                ? normalButton("Connect", () {
                    connect(wcUri!);
                  }, width: 200)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Web3Wallet? wcClient;
  Future walletConnect() async {
    wcClient = await Web3Wallet.createInstance(
      projectId: '602617b1157a2c68b1afc1b97d6ffd45',
      metadata: const PairingMetadata(
        name: 'HenryWCV2Test1',
        description: 'Henry Wallet Connect V2 Test 1',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );

    // For a wallet, setup the proposal handler that will display the proposal to the user after the URI has been scanned.
    wcClient?.onSessionProposal.subscribe((SessionProposalEvent? args) async {
      // Handle UI updates using the args.params
      // Keep track of the args.id for the approval response

      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text(
          "Session Proposal",
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 200,
          height: 200,
          child: SingleChildScrollView(child: Text(args!.params.toString())),
        ),
        actions: <Widget>[
          normalButton("Cancel", () => Navigator.of(context).pop(), color: Colors.blueGrey),
          normalButton("Connect", () {
            approveSession(args.id);
            Navigator.of(context).pop();
          }),
        ],
      ).show(context);
      // Dialogs.materialDialog(
      //     context: context,
      //     title: "Session Proposal",
      //     msg: "args?.params.toString()",
      //     customView: Container(
      //       width: 200,
      //       height: 200,
      //       child: SingleChildScrollView(child: Text("test")),
      //     ),
      //     actions: [
      //       IconButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         icon: const Icon(Icons.close),
      //       ),
      //       IconButton(
      //         onPressed: () {
      //           approveSession(args!.id);
      //           Navigator.of(context).pop();
      //         },
      //         icon: const Icon(Icons.check),
      //       ),
      //     ]);
    });

    // Also setup the methods and chains that your wallet supports

    // wcClient.registerRequestHandler(
    //   chainId: 'eip155:1',
    //   method: 'eth_sendTransaction',
    //   handler: signRequestHandler,
    // );

    // If you want to the library to handle Namespace validation automatically,
    // you can register your events and accounts like so:
    // wcClient.registerEventEmitter(
    //   chainId: 'eip155:1',
    //   event: 'chainChanged',
    // );
    // wcClient.registerAccount(
    //   chainId: 'eip155:1',
    //   accountAddress: '0xabc',
    // );

    // If your wallet receives a session proposal that it can't make the proper Namespaces for,
    // it will broadcast an onSessionProposalError
    // wcClient.onSessionProposalError.subscribe((SessionProposalErrorEvent? args) {
    //   // Handle the error
    // });

    // Setup the auth handling
    // wcClient.onAuthRequest.subscribe((AuthRequest? args) async {
    //   // This is where you would
    //   // 1. Store the information to be signed
    //   // 2. Display to the user that an auth request has been received

    //   // You can create the message to be signed in this manner
    //   // String message = wcClient.formatAuthMessage(
    //   //   iss: TEST_ISSUER_EIP191,
    //   //   cacaoPayload: CacaoRequestPayload.fromPayloadParams(
    //   //     args!.payloadParams,
    //   //   ),
    //   // );
    // });

    // For auth, you can do the same thing: Present the UI to them, and have them approve the signature.
    // Then respond with that signature. In this example I use EthSigUtil, but you can use any library that can perform
    // a personal eth sign.
    // String sig = EthSigUtil.signPersonalMessage(
    //   message: Uint8List.fromList("message".codeUnits),
    //   privateKey: 'PRIVATE_KEY',
    // );
    // await wcClient.respondAuthRequest(
    //   id: int.tryParse("args.id")!,
    //   iss: 'did:pkh:eip155:1:ETH_ADDRESS',
    //   signature: CacaoSignature(t: CacaoSignature.EIP191, s: sig),
    // );
    // Or rejected
    // Error codes and reasons can be found here: https://docs.walletconnect.com/2.0/specs/clients/sign/error-codes
    // await wcClient.respondAuthRequest(
    //   id: int.tryParse("args.id")!,
    //   iss: 'did:pkh:eip155:1:0x06C6A22feB5f8CcEDA0db0D593e6F26A3611d5fa',
    //   error: Errors.getSdkError(Errors.USER_REJECTED_AUTH),
    // );

    // You can also emit events for the dApp
    // await wcClient.emitSessionEvent(
    //   topic: "sessionTopic",
    //   chainId: 'eip155:1',
    //   event: const SessionEventParams(
    //     name: 'chainChanged',
    //     data: 'a message!',
    //   ),
    // );
  }

  PairingInfo? pairing;
  connect(String wcUri) async {
    // Then, scan the QR code and parse the URI, and pair with the dApp
    // On the first pairing, you will immediately receive onSessionProposal and onAuthRequest events.
    Uri uri = Uri.parse(wcUri);
    pairing = await wcClient?.pair(uri: uri);
  }

  disconnect() async {
    // Finally, you can disconnect
    if (pairing != null) {
      await wcClient?.disconnectSession(
        topic: pairing!.topic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
    }
  }

  signRequestHandler(String topic, dynamic parameters) async {
    // Handling Steps
    // 1. Parse the request, if there are any errors thrown while trying to parse
    // the client will automatically respond to the requester with a
    // JsonRpcError.invalidParams error
    final parsedResponse = parameters;

    // 1. If you want to fail silently, you can throw a WalletConnectErrorSilent
    if ("failSilently".isNotEmpty) {
      throw WalletConnectErrorSilent();
    }

    // 2. Show a modal to the user with the signature info: Allow approval/rejection
    bool userApproved = await showDialog(
      // This is an example, you will have to make your own changes to make it work.
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Transaction'),
          content: SizedBox(
            width: 300,
            height: 350,
            child: Text(parsedResponse.toString()),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Accept'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );

    // 3. Respond to the dApp based on user response
    if (userApproved) {
      // Returned value must be a primitive, or a JSON serializable object: Map, List, etc.
      return 'Signed!';
    } else {
      // Throw an error if the user rejects the request
      throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
    }
  }

  approveSession(int id) async {
    // Present the UI to the user, and allow them to reject or approve the proposal
    final walletNamespaces = {
      'eip155': const Namespace(
        accounts: ['eip155:1:abc'],
        methods: ['eth_signTransaction'],
        events: [],
      ),
      'kadena': const Namespace(
        accounts: ['kadena:mainnet01:abc'],
        methods: ['kadena_sign_v1', 'kadena_quicksign_v1'],
        events: ['kadena_transaction_updated'],
      ),
    };
    await wcClient?.approveSession(id: id, namespaces: walletNamespaces // This will have the accounts requested in params
        );
    // Or to reject...
    // Error codes and reasons can be found here: https://docs.walletconnect.com/2.0/specs/clients/sign/error-codes
    await wcClient?.rejectSession(
      id: id,
      reason: Errors.getSdkError(Errors.USER_REJECTED),
    );
  }

  String? wcUri;
  Future scanQR() async {
    // granted准予、denied拒绝、restricted限制、permanentlyDenied永久拒绝、limited限制、 provisional临时的
    if (await Permission.camera.request().isGranted) {
      String? cameraScanResult = await scanner.scan();
      log.fine("cameraScanResult: $cameraScanResult");
      setState(() {
        wcUri = cameraScanResult;
      });
    } else if (mounted) {
      Dialogs.materialDialog(
          msg: 'You has been denied the camera, please granted it',
          title: "No permission",
          color: Colors.white,
          context: context,
          actions: [
            normalButton("Cancel", color: Colors.blueGrey, () {
              Navigator.of(context).pop();
            }),
            normalButton("Settings", () {
              openAppSettings();
            })
          ]);
    }
  }
}

// import 'package:eth_sig_util/eth_sig_util.dart';

// String signature = EthSigUtil.signTypedData(privateKey: '4af...bb0', jsonData: '{...}', version: TypedDataVersion.V4);

// String signature = EthSigUtil.signPersonalTypedData(privateKey: '4af...bb0', jsonData: '{...}', version: TypedDataVersion.V4);

// String signature = EthSigUtil.signMessage(privateKey: '4af...bb0', message: []);

// String signature = EthSigUtil.signPersonalMessage(privateKey: '4af...bb0', message: []);

// String address = EthSigUtil.recoverSignature(signature: '0x84ea3...', message: []);

// String address = EthSigUtil.recoverPersonalSignature(signature: '0x84ea3...', message: []);