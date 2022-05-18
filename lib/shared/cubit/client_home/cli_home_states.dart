abstract class CliStates {}

class CliInitialState extends CliStates {}

class CliChangeBottomNavState extends CliStates {}

class GetBillsSuccessState extends CliStates {}

class CliErrorState extends CliStates {
  final String error;

  CliErrorState(this.error);
}
