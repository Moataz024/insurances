abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeSuccessState extends HomeStates {}

class GetEmployeeLoadingState extends HomeStates {}

class GetClientsLoadingState extends HomeStates {}

class GetEmployeeSuccessState extends HomeStates {}

class GetClientsSuccessState extends HomeStates {}

class DeleteLoadingState extends HomeStates {}

class DeleteSuccessState extends HomeStates {}

class HomeErrorState extends HomeStates {
  final String error;

  HomeErrorState(this.error);
}
class GetEmployeeErrorState extends HomeStates {
  final String error;

  GetEmployeeErrorState(this.error);
}
class GetClientsErrorState extends HomeStates {
  final String error;

GetClientsErrorState(this.error);
}
