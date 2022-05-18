abstract class InsurancesClientStates {}

class InsurancesClientInitialState extends InsurancesClientStates {}

class InsurancesClientCreationSuccessState extends InsurancesClientStates {
  final String uid;

  InsurancesClientCreationSuccessState(this.uid);
}

class InsurancesClientCreationErrorState extends InsurancesClientStates {
  final String error;

  InsurancesClientCreationErrorState(this.error);
}

class InsurancesClientLoadingState extends InsurancesClientStates {}
