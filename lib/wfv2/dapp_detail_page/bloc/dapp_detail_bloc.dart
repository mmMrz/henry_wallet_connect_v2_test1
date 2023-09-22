import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dapp_detail_event.dart';
part 'dapp_detail_state.dart';

class DappDetailBloc extends Bloc<DappDetailEvent, DappDetailState> {
  DappDetailBloc() : super(DappDetailInitial()) {
    on<DappDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
