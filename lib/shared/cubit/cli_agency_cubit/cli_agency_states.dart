abstract class CliAgencyStates {}

class CliAgencyInitialState extends CliAgencyStates {}

class GetAgencySuccessState extends CliAgencyStates {}

class LoadingAgencyState extends CliAgencyStates {}

class GetAgencyErrorState extends CliAgencyStates {
  final error;

  GetAgencyErrorState(this.error);
}

