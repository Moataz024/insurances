abstract class InsurancesAgencyStates {}

class InsurancesAgencyInitialState extends InsurancesAgencyStates {}

class InsurancesAgencyGetSuccessState extends InsurancesAgencyStates {}

class InsurancesAgencyGetErrorState extends InsurancesAgencyStates {
  final String error;

  InsurancesAgencyGetErrorState(this.error);
}

class InsurancesAgencyGetLoadingState extends InsurancesAgencyStates {}
