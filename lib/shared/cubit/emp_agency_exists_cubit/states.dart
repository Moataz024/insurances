abstract class EmpStates {}

class EmpInitialState extends EmpStates {}

class CreateEmployeeLoadingState extends EmpStates {}

class CreateEmployeeSuccessState extends EmpStates {}

class CreateEmployeeErrorState extends EmpStates {
  final String error;

  CreateEmployeeErrorState(this.error);
}

