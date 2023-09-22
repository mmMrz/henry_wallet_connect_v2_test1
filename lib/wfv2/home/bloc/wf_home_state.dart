part of 'wf_home_bloc.dart';

abstract class WfHomeState extends Equatable {
  const WfHomeState({this.activeSessions, this.wcUri, this.args, this.showSessionProposalDialog, this.showNoCameraPermissionDialog});

  final Map<String, SessionData>? activeSessions;
  final String? wcUri;

  final SessionProposalEvent? args;
  final bool? showSessionProposalDialog;

  final bool? showNoCameraPermissionDialog;

  @override
  List<Object?> get props => [activeSessions, wcUri, args, showSessionProposalDialog, showNoCameraPermissionDialog];

  WfHomeState copyWith({
    Map<String, SessionData>? activeSessions,
    String? wcUri,
    SessionProposalEvent? args,
    bool? showSessionProposalDialog,
    bool? showNoCameraPermissionDialog,
  });
}

class WfHomeStateInitial extends WfHomeState {
  const WfHomeStateInitial({
    super.activeSessions,
    super.wcUri,
    super.args,
    super.showSessionProposalDialog,
    super.showNoCameraPermissionDialog,
  });

  @override
  WfHomeState copyWith({
    Map<String, SessionData>? activeSessions,
    String? wcUri,
    SessionProposalEvent? args,
    bool? showSessionProposalDialog,
    bool? showNoCameraPermissionDialog,
  }) {
    return WfHomeStateInitial(
      activeSessions: activeSessions ?? this.activeSessions,
      wcUri: wcUri ?? this.wcUri,
      args: args ?? this.args,
      showSessionProposalDialog: showSessionProposalDialog ?? this.showSessionProposalDialog,
      showNoCameraPermissionDialog: showNoCameraPermissionDialog ?? this.showNoCameraPermissionDialog,
    );
  }
}
