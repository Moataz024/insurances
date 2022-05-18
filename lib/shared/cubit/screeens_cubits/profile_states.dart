abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {}

class LoadingDeleteState extends ProfileStates {}

class SuccessDeleteState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {
  final String error;

  ProfileErrorState(this.error);
}
class GetEmployeeErrorState extends ProfileStates {
  final String error;

  GetEmployeeErrorState(this.error);
}
class CoWorkersErrorState extends ProfileStates {
  final String error;

  CoWorkersErrorState(this.error);
}

class GetEmployeeLoadingState extends ProfileStates {}

class GetEmployeeSuccessState extends ProfileStates {}

class CoWorkersLoadingState extends ProfileStates {}

class CoWorkersEmptyState extends ProfileStates {}

class CoWorkersSuccessState extends ProfileStates {}
