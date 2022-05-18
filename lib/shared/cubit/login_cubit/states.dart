abstract class InsurancesLoginStates {}

class InsurancesLoginInitialState extends InsurancesLoginStates {}

class InsurancesLoginSuccessState extends InsurancesLoginStates {
  final String uid;

  InsurancesLoginSuccessState(this.uid);
}

class InsurancesLoginErrorState extends InsurancesLoginStates {
  final String error;

  InsurancesLoginErrorState(this.error);
}

class InsurancesLoadingLogin extends InsurancesLoginStates {}

class InsurancesRegisterState extends InsurancesLoginStates {}

class InsurancesChangePasswordVisibilityState extends InsurancesLoginStates {}

class InsurancesLoadingHomeState extends InsurancesLoginStates {}

