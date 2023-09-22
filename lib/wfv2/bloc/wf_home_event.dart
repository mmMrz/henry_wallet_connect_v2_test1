part of 'wf_home_bloc.dart';

abstract class WfHomeEvent extends Equatable {
  const WfHomeEvent();
}

class ActiveSessionUpdatedEvent extends WfHomeEvent {
  const ActiveSessionUpdatedEvent({required this.activeSessions});

  final Map<String, SessionData>? activeSessions;

  @override
  List<Object?> get props => [activeSessions];
}

class WcUriUpdatedEvent extends WfHomeEvent {
  const WcUriUpdatedEvent({required this.wcUri});

  final String? wcUri;

  @override
  List<Object?> get props => [wcUri];
}

class NoPermissionEvent extends WfHomeEvent {
  const NoPermissionEvent();

  @override
  List<Object?> get props => [];
}

class OnSessionProposalEvent extends WfHomeEvent {
  const OnSessionProposalEvent({required this.args});

  final SessionProposalEvent? args;

  @override
  List<Object?> get props => [args];
}
