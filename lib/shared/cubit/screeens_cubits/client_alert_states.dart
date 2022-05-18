abstract class ClientAlertStates {}

class ClientAlertInitialState extends ClientAlertStates {}

class ClientAlertChangePasswordVisibility extends ClientAlertStates {}

class CurrentEmailState extends ClientAlertStates {}

class ClientAlertErrorState extends ClientAlertStates {
  final String error;

  ClientAlertErrorState(this.error);
}
