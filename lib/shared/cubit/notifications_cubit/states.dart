abstract class NotifStates {}

class NotifInitialState extends NotifStates {}

class ErrorState extends NotifStates {
  final String error;

  ErrorState(this.error);
}

class LoadingState extends NotifStates {}

class SuccessState extends NotifStates {}
class LoadingAcceptingMeetingState extends NotifStates {}
class AcceptedMeetingState extends NotifStates {}
class LoadingDecliningMeetingState extends NotifStates {}
class DeclinedMeetingState extends NotifStates {}
class LoadingAcceptingMemberState extends NotifStates {}
class AcceptedMemberState extends NotifStates {}
class LoadingDecliningMemberState extends NotifStates {}
class DeclinedMemberState extends NotifStates {}