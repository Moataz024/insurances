abstract class PhoneLoginStates {}

class PhoneLoginInitialState extends PhoneLoginStates {}

class PhoneLoginSuccessState extends PhoneLoginStates {
  final String uid;

  PhoneLoginSuccessState(this.uid);
}

class PhoneLoginErrorState extends PhoneLoginStates {
  final String error;

  PhoneLoginErrorState(this.error);
}

class LoadingPhoneLogin extends PhoneLoginStates {}

class PhoneLoginChangePasswordVisibilityState extends PhoneLoginStates {}

class PhoneLoginLoadingHomeState extends PhoneLoginStates {}

