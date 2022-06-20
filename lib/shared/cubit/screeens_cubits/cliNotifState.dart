abstract class CliNotifStates {}

class CliNotifInitialState extends CliNotifStates {}

class LoadingNotificationState extends CliNotifStates {}

class NotificationSuccessState extends CliNotifStates {}

class NotificationErrorState extends CliNotifStates {
  final String error;

  NotificationErrorState(this.error);
}
