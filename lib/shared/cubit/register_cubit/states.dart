abstract class InsurancesRegisterStates {}

class InsurancesRegisterInitialState extends InsurancesRegisterStates {}

class InsurancesRegisterSuccessState extends InsurancesRegisterStates {}

class InsurancesRegisterErrorState extends InsurancesRegisterStates {
  final String error;

  InsurancesRegisterErrorState(this.error);
}

class InsurancesUserCreationSuccessState extends InsurancesRegisterStates {}

class InsurancesUserCreationLoadingState extends InsurancesRegisterStates {}

class InsurancesUserCreationErrorState extends InsurancesRegisterStates {
  final String error;

  InsurancesUserCreationErrorState(this.error);
}

class InsurancesLoadingRegisterState extends InsurancesRegisterStates {}

class InsurancesCreationLoadingRegisterState extends InsurancesRegisterStates {}

class InsurancesChangePasswordVisibilityState extends InsurancesRegisterStates {}

class InsurancesChangeDropDownValueState extends InsurancesRegisterStates {}

class InsurancesAgencyCreationSuccessState extends InsurancesRegisterStates {}

class InsurancesAgencyCreationLoadingState extends InsurancesRegisterStates {}

class InsurancesAgencyCreationErrorState extends InsurancesRegisterStates {
  final String error;

  InsurancesAgencyCreationErrorState(this.error);
}

class InsurancesEmployeeCreationSuccessState extends InsurancesRegisterStates {}

class InsurancesEmployeeCreationLoadingState extends InsurancesRegisterStates {}

class InsurancesEmployeeCreationErrorState extends InsurancesRegisterStates {
  final String error;

  InsurancesEmployeeCreationErrorState(this.error);
}