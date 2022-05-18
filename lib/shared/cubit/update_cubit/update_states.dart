abstract class UpdateStates {}

class UpdateInitialState extends UpdateStates {}

class GetEmpLoadingState extends UpdateStates {}

class GetEmpSuccessState extends UpdateStates {}

class UpdateEmployeeLoadingState extends UpdateStates {}

class UpdateEmployeeSuccessState extends UpdateStates {}

class GetEmpErrorState extends UpdateStates {
  final error;

  GetEmpErrorState(this.error);
}

class UpdateEmployeeErrorState extends UpdateStates {
  final error;

  UpdateEmployeeErrorState(this.error);
}




