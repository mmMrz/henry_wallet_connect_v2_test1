// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

// Project imports:
import 'package:QRTest_v2_test1/wfv2/client/wc_client.dart';

part 'dapp_detail_event.dart';
part 'dapp_detail_state.dart';

class DappDetailBloc extends Bloc<DappDetailEvent, DappDetailState> {
  DappDetailBloc() : super(DappDetailInitial()) {
    on<DappDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  disconnect(String topic) {
    WFV2Client.getInstance().wcClient.disconnectSession(
        topic: topic, reason: Errors.getSdkError(Errors.USER_DISCONNECTED));
  }
}
