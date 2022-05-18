abstract class EmployeeStates {}

class EmployeeInitialState extends EmployeeStates {}

class EmployeeGetLoadingState extends EmployeeStates {}

class EmployeeGetSuccessState extends EmployeeStates {}

class EmployeeGetErrorState extends EmployeeStates {
  final error;
  EmployeeGetErrorState(this.error);
}

class EmployeeChangeBottomBarState extends EmployeeStates {}
