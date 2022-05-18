abstract class ChargeStates {}

class ChargeInitialState extends ChargeStates {}

class CreateBillSuccessState extends ChargeStates {}

class CreateBillLoadingState extends ChargeStates {}

class ChargeChangeDropDownValueState extends ChargeStates {}

class CreateBillErrorState extends ChargeStates {
  final String error;

  CreateBillErrorState(this.error);
}

