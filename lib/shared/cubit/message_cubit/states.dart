abstract class MessageStates {}

class MessageInitialState extends MessageStates {}

class SendMessageSuccessState extends MessageStates {}

class SendMessageLoadingState extends MessageStates {}

class GetMessageLoadingState extends MessageStates {}

class GetMessageSuccessState extends MessageStates {}

class SendMessageErrorState extends MessageStates {
  final String error;

  SendMessageErrorState(this.error);
}

class GetEmployeeLoadingState extends MessageStates {}

class GetEmployeeSuccessState extends MessageStates {}

class GetEmployeeErrorState extends MessageStates {
  final String error;

  GetEmployeeErrorState(this.error);
}


