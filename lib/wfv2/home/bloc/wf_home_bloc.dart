import 'package:QRTest_v2_test1/utils/logger_utils.dart';
import 'package:QRTest_v2_test1/utils/wallet/chain_enum.dart';
import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';
import 'package:QRTest_v2_test1/wfv2/client/wc_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:qrscan/qrscan.dart' as scanner;

part 'wf_home_event.dart';
part 'wf_home_state.dart';

class WfHomeBloc extends Bloc<WfHomeEvent, WfHomeState> {
  WfHomeBloc() : super(const WfHomeStateInitial()) {
    on<WfHomeEvent>((event, emit) {
      if (event is ActiveSessionUpdatedEvent) {
        emit(state.copyWith(activeSessions: event.activeSessions));
      } else if (event is OnSessionProposalEvent) {
        emit(state.copyWith(args: event.args, showSessionProposalDialog: event.showSessionProposalDialog));
      } else if (event is NoPermissionEvent) {
        emit(state.copyWith(showNoCameraPermissionDialog: event.showNoCameraPermissionDialog));
      } else if (event is WcUriUpdatedEvent) {
        emit(state.copyWith(wcUri: event.wcUri));
      }
    });
    walletConnect();
  }

  late Web3Wallet wcClient;

  walletConnect() async {
    //初始化WalletClient
    await WFV2Client.getInstance().init();
    wcClient = WFV2Client.getInstance().wcClient;

    refreshActiveSession();

    //注册一个事件监听,这是当请求来临时的回调
    // For a wallet, setup the proposal handler that will display the proposal to the user after the URI has been scanned.
    wcClient.onSessionProposal.subscribe((SessionProposalEvent? args) async {
      // Handle UI updates using the args.params
      // Keep track of the args.id for the approval response
      add(OnSessionProposalEvent(args: args, showSessionProposalDialog: true));
    });

    // If your wallet receives a session proposal that it can't make the proper Namespaces for,
    // it will broadcast an onSessionProposalError
    wcClient.onSessionProposalError.subscribe((SessionProposalErrorEvent? args) {
      // Handle the error
      log.d("receives a session proposal that it can't make the proper Namespaces for");
    });

    wcClient.onSessionDelete.subscribe((SessionDelete? args) {
      // Handle the session deletion
      log.d("onSessionDeleted");
      refreshActiveSession();
    });

    //这里可以注册一些我的钱包支持的链
    // Also setup the methods and chains that your wallet supports

    // wcClient?.registerRequestHandler(
    //   chainId: 'eip155:1',
    //   method: 'eth_sendTransaction',
    //   handler: signRequestHandler,
    // );

    wcClient.core.relayClient.onRelayClientMessage.subscribe((MessageEvent? args) {
      log.d("WC2:RelayClient:onRelayClientMessage:$args");
      log.d(args?.message);
      log.d(args?.topic);
    });

    // If you want to the library to handle Namespace validation automatically,
    // you can register your events and accounts like so:
    // wcClient?.registerEventEmitter(
    //   chainId: 'eip155:1',
    //   event: 'chainChanged',
    // );
    // wcClient?.registerAccount(
    //   chainId: 'eip155:1',
    //   accountAddress: '0xabc',
    // );

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

  //当扫描二维码配对连接成功后，会返回一个PairingInfo对象
  PairingInfo? pairing;
  connect(String wcUri) async {
    // Then, scan the QR code and parse the URI, and pair with the dApp
    // On the first pairing, you will immediately receive onSessionProposal and onAuthRequest events.

    log.d("开始准备连接");
    Uri uri = Uri.parse(wcUri);
    pairing = await wcClient.pair(uri: uri);
  }

  //断开连接
  disconnect() async {
    // Finally, you can disconnect
    if (pairing != null) {
      await wcClient.disconnectSession(
        topic: pairing!.topic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
    }
  }

  //批准会话
  approveSession(int id, ProposalData params) async {
    // Present the UI to the user, and allow them to reject or approve the proposal

    final Map<String, Namespace> walletNamespaces = {};
    //根据需要的链来完善返回的命名空间
    params.requiredNamespaces.forEach((key, value) {
      value.chains?.forEach((element) {
        //这里是要求的每个链条，比如eip155:1，kadena:mainnet01，这里要求的是eip155:1:account，所以需要加上account
        //那要从本地找到
        // namespace + ":" + reference + ":" + account
        //获取到链的Enum
        ChainEnum? chainEnum = chainEnumByCaip2Semantics(element);
        if (chainEnum != null) {
          var accountAddress = WalletUtils.getInstance().getAddress(chainEnum, WalletUtils.getInstance().getPublicKey(chainEnum));
          walletNamespaces[key] = Namespace(
            accounts: ['$element:$accountAddress'],
            methods: value.methods,
            events: value.events,
          );
        }
      });
    });

    await wcClient.approveSession(id: id, namespaces: walletNamespaces);
    refreshActiveSession();
  }

  refreshActiveSession() {
    Map<String, SessionData> activeSessions = wcClient.getActiveSessions();
    log.d(activeSessions.toString());
    if (activeSessions.isNotEmpty) {
      add(ActiveSessionUpdatedEvent(activeSessions: activeSessions));
    } else {
      add(const ActiveSessionUpdatedEvent(activeSessions: {}));
    }
  }

  //拒绝会话
  rejectSession(int id) async {
    // Or to reject...
    // Error codes and reasons can be found here: https://docs.walletconnect.com/2.0/specs/clients/sign/error-codes
    await wcClient.rejectSession(
      id: id,
      reason: Errors.getSdkError(Errors.USER_REJECTED),
    );
  }

  //签名请求处理
  // signRequestHandler(String topic, dynamic parameters) async {
  //   // Handling Steps
  //   // 1. Parse the request, if there are any errors thrown while trying to parse
  //   // the client will automatically respond to the requester with a
  //   // JsonRpcError.invalidParams error
  //   final parsedResponse = parameters;

  //   // 1. If you want to fail silently, you can throw a WalletConnectErrorSilent
  //   if ("failSilently".isNotEmpty) {
  //     throw WalletConnectErrorSilent();
  //   }

  //   // 2. Show a modal to the user with the signature info: Allow approval/rejection
  //   bool userApproved = await showDialog(
  //     // This is an example, you will have to make your own changes to make it work.
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Sign Transaction'),
  //         content: SizedBox(
  //           width: 300,
  //           height: 350,
  //           child: Text(parsedResponse.toString()),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(context, true),
  //             child: const Text('Accept'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: const Text('Reject'),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   // 3. Respond to the dApp based on user response
  //   if (userApproved) {
  //     // Returned value must be a primitive, or a JSON serializable object: Map, List, etc.
  //     return 'Signed!';
  //   } else {
  //     // Throw an error if the user rejects the request
  //     throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
  //   }
  // }

  //注册一些钱包支持的链

  //扫描二维码，结束后会更新界面上的wcUri显示出来
  String? wcUri;
  Future scanQR() async {
    // granted准予、denied拒绝、restricted限制、permanentlyDenied永久拒绝、limited限制、 provisional临时的
    if (await Permission.camera.request().isGranted) {
      String? cameraScanResult = await scanner.scan();
      log.d("cameraScanResult: $cameraScanResult");
      add(WcUriUpdatedEvent(wcUri: cameraScanResult));
    } else {
      //如果没有权限，就弹出一个对话框，提示用户去设置里面打开权限
      add(const NoPermissionEvent(showNoCameraPermissionDialog: true));
    }
  }
}