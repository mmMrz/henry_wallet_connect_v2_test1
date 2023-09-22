part of 'wf_home_bloc.dart';

abstract class WfHomeState extends Equatable {
  const WfHomeState({this.activeSessions, this.wcUri});

  final Map<String, SessionData>? activeSessions;
  final String? wcUri;

  @override
  List<Object?> get props => [activeSessions, wcUri];
}

class WfHomeStateInitial extends WfHomeState {
  const WfHomeStateInitial({super.activeSessions, super.wcUri});
}

class NoPermissionState extends WfHomeState {
  const NoPermissionState({super.activeSessions, super.wcUri});
}

class WfHomeSessionProposalState extends WfHomeState {
  const WfHomeSessionProposalState({super.activeSessions, super.wcUri, this.args});
  final SessionProposalEvent? args;
  @override
  List<Object?> get props => [args];
}
