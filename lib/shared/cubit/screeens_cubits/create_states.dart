abstract class CreateEmployeeStates {}

class CreateEmployeeInitialState extends CreateEmployeeStates {}

class CreateEmployeeSuccessState extends CreateEmployeeStates {}

class CreateEmployeeLoadingState extends CreateEmployeeStates {}

class GetCurrentEmailState extends CreateEmployeeStates {}

class CreateEmployeeErrorState extends CreateEmployeeStates {
  final String error;

  CreateEmployeeErrorState(this.error);
}
class CreateEmployeeChangePasswordVisibilityState extends CreateEmployeeStates {}

class RegisterEmployeeSuccessState extends CreateEmployeeStates {}

class RegisterEmployeeLoadingState extends CreateEmployeeStates {}

class RegisterEmployeePrintState extends CreateEmployeeStates {}

class ReSignInLoadingState extends CreateEmployeeStates {}

class ReSignInSuccessState extends CreateEmployeeStates {}

class ReSignInSignOutState extends CreateEmployeeStates {}

class RegisterEmployeeErrorState extends CreateEmployeeStates {
  final String error;

  RegisterEmployeeErrorState(this.error);
}
class ReSignInErrorState extends CreateEmployeeStates {
  final String error;

  ReSignInErrorState(this.error);
}
