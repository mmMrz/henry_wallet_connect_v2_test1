import 'dart:convert';
import 'dart:typed_data';

import 'package:QRTest_v2_test1/entity/ukwc_transaction.dart';
import 'package:QRTest_v2_test1/main.dart';
import 'package:QRTest_v2_test1/utils/logger_utils.dart';
import 'package:QRTest_v2_test1/utils/wallet/chain_enum.dart';
import 'package:QRTest_v2_test1/utils/wallet/eth_utils.dart';
import 'package:QRTest_v2_test1/utils/wallet/wallet_utils.dart';
import 'package:QRTest_v2_test1/wfv2/client/wc_client.dart';
import 'package:QRTest_v2_test1/widget/button.dart';
import 'package:convert/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

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

    wcClient.onSessionConnect.subscribe((SessionConnect? args) {
      // Handle the session deletion
      log.d("onSessionConnect");
      refreshActiveSession();
    });
    wcClient.onSessionDelete.subscribe((SessionDelete? args) {
      // Handle the session deletion
      log.d("onSessionDeleted");
      refreshActiveSession();
    });
    wcClient.onSessionRequest.subscribe((SessionRequestEvent? args) {
      log.d("onSessionRequest-----start");
      log.d("id:->${args?.id}");
      log.d("topic->${args?.topic}");
      log.d("method->{$args?.method}");
      log.d("chaiId->{$args?.chainId}");
      log.d("params->${args?.params}");
      log.d("onSessionRequest-----end");
    });

    //这里可以注册一些我的钱包支持的链
    //这里必须要循环调用
    ChainEnum.values.forEach((element) {
      String? caip2id = caip2Map[element];
      if (caip2id != null && caip2id.startsWith("eip155:")) {
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_sign',
          handler: signHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'personal_sign',
          handler: personalSignHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_signTypedData',
          handler: signTypedDataHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_signTypedData_v3',
          handler: signTypedDataHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_signTypedData_v4',
          handler: signTypedDataHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_signTransaction',
          handler: signTransactionHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_sendTransaction',
          handler: sendTransactionHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'eth_sendRawTransaction',
          handler: sendRawTransactionHandler,
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'wallet_addEthereumChain',
          handler: (String topic, dynamic parameters) {
            log.d("wallet_addEthereumChain");
            log.d("parameters->${parameters.toString()}");
            int chatId = hexToDartInt(parameters[0]["chainId"]);
            String? caip2Id = caip2Map["eip155:$chatId"];
            bool supported = false;
            if (caip2Id != null) {
              ChainEnum? chainEnum = chainEnumByCaip2Semantics(caip2Id);
              if (chainEnum != null) {
                supported = true;
              }
            }
            if (supported) {
              return null;
            } else {
              return Errors.getSdkError(Errors.UNSUPPORTED_CHAINS);
            }
          },
        );
        wcClient.registerRequestHandler(
          chainId: caip2id,
          method: 'wallet_switchEthereumChain',
          handler: (String topic, dynamic parameters) {
            log.d("wallet_switchEthereumChain");
            log.d("parameters->${parameters.toString()}");
            int chatId = hexToDartInt(parameters[0]["chainId"]);
            String? caip2Id = caip2Map["eip155:$chatId"];
            bool supported = false;
            if (caip2Id != null) {
              ChainEnum? chainEnum = chainEnumByCaip2Semantics(caip2Id);
              if (chainEnum != null) {
                supported = true;
              }
            }
            if (supported) {
              return null;
            } else {
              return Errors.getSdkError(Errors.UNSUPPORTED_CHAINS);
            }
          },
        );
      }
    });
// https: //polygon-rpc.com
    // wcClient?.registerRequestHandler(
    //   chainId: 'eip155:1',
    //   method: 'eth_sendTransaction',
    //   handler: signRequestHandler,asdf
    // );

    wcClient.onSessionPing.subscribe((SessionPing? args) {
      log.d(args?.id.toString());
      log.d(args?.topic);
    });

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

    log.d("开始准备连接:$wcUri");
    Uri uri = Uri.parse(wcUri);
    try {
      pairing = await wcClient.pair(uri: uri);
    } on WalletConnectError catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
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
    bool supportedAllRequired = true;
    List<String> notSupportedChains = [];
    //根据需要的链来完善返回的命名空间
    params.requiredNamespaces.forEach((key, value) {
      value.chains?.forEach((element) {
        //这里是要求的每个链条，比如eip155:1，kadena:mainnet01，这里要求的是eip155:1:account，所以需要加上account
        //那要从本地找到
        // namespace + ":" + reference + ":" + account
        //获取到链的Enum
        ChainEnum? chainEnum = chainEnumByCaip2Semantics(element);
        if (chainEnum != null) {
          var accountAddress = WalletUtils.getInstance().getAddress(chainEnum);
          Namespace? namespace = walletNamespaces[key];
          if (namespace != null) {
            List<String> accounts = List.of(namespace.accounts);
            accounts.add('$element:$accountAddress');
            //去除accounts里的重复项
            accounts = accounts.toSet().toList();

            List<String> methods = List.of(namespace.methods);
            methods.addAll(value.methods);
            //去除methods里的重复项
            methods = methods.toSet().toList();

            List<String> events = List.of(namespace.events);
            events.addAll(value.events);
            //去除events里的重复项
            events = events.toSet().toList();

            namespace = Namespace(
              accounts: accounts,
              methods: methods,
              events: events,
            );
          } else {
            namespace = Namespace(
              accounts: ['$element:$accountAddress'],
              methods: value.methods,
              events: value.events,
            );
          }
          walletNamespaces[key] = namespace;
        } else {
          supportedAllRequired = false;
          notSupportedChains.add(element);
        }
      });
    });

    if (!supportedAllRequired) {
      NDialog(
        dialogStyle: DialogStyle(titleDivider: true),
        title: const Text(
          "Some chain not supported",
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 200,
          height: 200,
          child: SingleChildScrollView(child: Text("Some requested chains is required but not supported currently:\n${notSupportedChains.join("\n")}")),
        ),
        actions: <Widget>[
          normalButton("Okay I know", () {
            Navigator.of(navigatorKey.currentContext!).pop();
          }, color: Colors.blueGrey),
        ],
      ).show(navigatorKey.currentContext!); //没有支持到全部的链，需要提示用户
      return;
    }

    params.optionalNamespaces.forEach((key, value) {
      value.chains?.forEach((element) {
        //这里是要求的每个链条，比如eip155:1，kadena:mainnet01，这里要求的是eip155:1:account，所以需要加上account
        //那要从本地找到
        // namespace + ":" + reference + ":" + account
        //获取到链的Enum
        ChainEnum? chainEnum = chainEnumByCaip2Semantics(element);
        if (chainEnum != null) {
          var accountAddress = WalletUtils.getInstance().getAddress(chainEnum);
          Namespace? namespace = walletNamespaces[key];
          if (namespace != null) {
            List<String> accounts = List.of(namespace.accounts);
            accounts.add('$element:$accountAddress');
            //去除accounts里的重复项
            accounts = accounts.toSet().toList();

            List<String> methods = List.of(namespace.methods);
            methods.addAll(value.methods);
            //去除methods里的重复项
            methods = methods.toSet().toList();

            List<String> events = List.of(namespace.events);
            events.addAll(value.events);
            //去除events里的重复项
            events = events.toSet().toList();

            namespace = Namespace(
              accounts: accounts,
              methods: methods,
              events: events,
            );
          } else {
            namespace = Namespace(
              accounts: ['$element:$accountAddress'],
              methods: value.methods,
              events: value.events,
            );
          }
          walletNamespaces[key] = namespace;
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

  signHandler(String topic, dynamic parameters) async {
    log.d("signRequestHandler-----start");
    log.d(topic);
    log.d(parameters.toString());
    log.d("signRequestHandler-----end");
    // Handling Steps
    // 1. Parse the request, if there are any errors thrown while trying to parse
    // the client will automatically respond to the requester with a
    // JsonRpcError.invalidParams error
    final parsedResponse = parameters;

    final String message = EthUtils.getUtf8Message(parameters[1]);

    // 1. If you want to fail silently, you can throw a WalletConnectErrorSilent
    // if ("failSilently".isNotEmpty) {
    //   throw WalletConnectErrorSilent();
    // }

    // 2. Show a modal to the user with the signature info: Allow approval/rejection
    bool userApproved = await showDialog(
      // This is an example, you will have to make your own changes to make it work.
      context: navigatorKey.currentContext!,
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
      try {
        final EthPrivateKey credentials = WalletUtils.getInstance().credentials;

        final String signature = hex.encode(
          credentials.signPersonalMessageToUint8List(
            Uint8List.fromList(
              utf8.encode(message),
            ),
          ),
        );
        log.d(signature);

        return '0x$signature';
      } catch (e) {
        log.d('error:');
        log.d(e.toString());
        return 'Failed';
      }
    } else {
      // Throw an error if the user rejects the request
      throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
    }
  }

  personalSignHandler(String topic, dynamic parameters) async {
    log.d("personalSignHandler-----start");
    log.d(topic);
    log.d(parameters.toString());
    log.d("personalSignHandler-----end");

    log.d('received personal sign request: $parameters');

    final String message = EthUtils.getUtf8Message(parameters[0]);

    final parsedResponse = parameters;

    bool userApproved = await showDialog(
      // This is an example, you will have to make your own changes to make it work.
      context: navigatorKey.currentContext!,
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
      try {
        final EthPrivateKey credentials = WalletUtils.getInstance().credentials;

        final String signature = hex.encode(
          credentials.signPersonalMessageToUint8List(
            Uint8List.fromList(
              utf8.encode(message),
            ),
          ),
        );

        return '0x$signature';
      } catch (e) {
        log.d(e.toString());
        return 'Failed';
      }
    } else {
      // Throw an error if the user rejects the request
      throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
    }
  }

  signTypedDataHandler(String topic, dynamic parameters) async {
    log.d("signTypedDataHandler-----start");
    log.d(topic);
    log.d(parameters.toString());
    log.d("signTypedDataHandler-----end");

    final parsedResponse = parameters;

    bool userApproved = await showDialog(
      // This is an example, you will have to make your own changes to make it work.
      context: navigatorKey.currentContext!,
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
      EthPrivateKey credentials = WalletUtils.getInstance().credentials;
      // credentials.
      final String data = parameters[1];

      return EthSigUtil.signTypedData(
        privateKey: bytesToHex(credentials.privateKey),
        jsonData: data,
        version: TypedDataVersion.V4,
      );
    } else {
      // Throw an error if the user rejects the request
      throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
    }
  }

  signTransactionHandler(String topic, dynamic parameters) async {
    log.d("signTransactionHandler-----start");
    log.d(topic);
    log.d(parameters.toString());
    log.d("signTransactionHandler-----end");

    final parsedResponse = parameters;

    bool userApproved = await showDialog(
      // This is an example, you will have to make your own changes to make it work.
      context: navigatorKey.currentContext!,
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
    if (!userApproved) {
      // Throw an error if the user rejects the request
      throw Errors.getSdkError(Errors.USER_REJECTED_SIGN);
    }

    // Load the private key
    EthPrivateKey credentials = WalletUtils.getInstance().credentials;

    UKWCTransaction ethTransaction = UKWCTransaction.fromJson(
      parameters[0],
    );

    // Construct a transaction from the EthereumTransaction object
    final transaction = Transaction(
      from: EthereumAddress.fromHex(ethTransaction.from),
      to: EthereumAddress.fromHex(ethTransaction.to),
      value: EtherAmount.fromBigInt(
        EtherUnit.wei,
        BigInt.tryParse(ethTransaction.value) ?? BigInt.zero,
      ),
      gasPrice: ethTransaction.gasPrice != null
          ? EtherAmount.fromBigInt(
              EtherUnit.wei,
              BigInt.tryParse(ethTransaction.gasPrice!) ?? BigInt.zero,
            )
          : null,
      maxFeePerGas: ethTransaction.maxFeePerGas != null
          ? EtherAmount.fromBigInt(
              EtherUnit.wei,
              BigInt.tryParse(ethTransaction.maxFeePerGas!) ?? BigInt.zero,
            )
          : null,
      maxPriorityFeePerGas: ethTransaction.maxPriorityFeePerGas != null
          ? EtherAmount.fromBigInt(
              EtherUnit.wei,
              BigInt.tryParse(ethTransaction.maxPriorityFeePerGas!) ?? BigInt.zero,
            )
          : null,
      maxGas: int.tryParse(ethTransaction.gasLimit ?? ''),
      nonce: int.tryParse(ethTransaction.nonce ?? ''),
      data: (ethTransaction.data != null && ethTransaction.data != '0x') ? Uint8List.fromList(hex.decode(ethTransaction.data!)) : null,
    );

    Web3Client ethClient = Web3Client('https://mainnet.infura.io/v3/51716d2096df4e73bec298680a51f0c5', http.Client());
    try {
      final Uint8List sig = await ethClient.signTransaction(
        credentials,
        transaction,
      );

      // Sign the transaction
      final String signedTx = hex.encode(sig);

      // Return the signed transaction as a hexadecimal string
      return '0x$signedTx';
    } catch (e) {
      print(e);
      return 'Failed';
    }
  }

  sendTransactionHandler(String topic, dynamic parameters) async {
    log.d("sendTransactionHandler-----start");
    log.d(topic);
    log.d(parameters.toString());
    log.d("sendTransactionHandler-----end");
  }

  sendRawTransactionHandler(String topic, dynamic parameters) async {
    log.d("sendRawTransactionHandler-----start");
    log.d(topic);
    log.d(parameters.toString());
    log.d("sendRawTransactionHandler-----end");
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
