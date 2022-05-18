abstract class AlertStates {}

class AlertInitialState extends AlertStates {}

class AlertChangePasswordVisibility extends AlertStates {}

class AlertErrorState extends AlertStates {
  final String error;

  AlertErrorState(this.error);
}
