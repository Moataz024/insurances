abstract class CreateClientStates {}

class CreateClientInitialState extends CreateClientStates {}

class CreateClientSuccessState extends CreateClientStates {}

class CreateClientLoadingState extends CreateClientStates {}

class GetCurrentEmailState extends CreateClientStates {}

class CreateClientErrorState extends CreateClientStates {
  final String error;

  CreateClientErrorState(this.error);
}
class CreateClientChangePasswordVisibilityState extends CreateClientStates {}

class RegisterClientSuccessState extends CreateClientStates {}

class RegisterClientLoadingState extends CreateClientStates {}

class RegisterClientPrintState extends CreateClientStates {}

class ReSignInLoadingState extends CreateClientStates {}

class ReSignInSuccessState extends CreateClientStates {}

class ReSignInSignOutState extends CreateClientStates {}

class UpdateClientSuccessState extends CreateClientStates {}

class UpdateClientLoadingState extends CreateClientStates {}

class RegisterClientErrorState extends CreateClientStates {
  final String error;

  RegisterClientErrorState(this.error);
}
class ReSignInErrorState extends CreateClientStates {
  final String error;

  ReSignInErrorState(this.error);
}
class UpdateClientErrorState extends CreateClientStates {
  final String error;

  UpdateClientErrorState(this.error);
}

