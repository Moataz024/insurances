import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/bill_model.dart';
import 'package:insurances/notification_api.dart';

import '../../componenets/constants.dart';
import 'charge_states.dart';

class ChargeCubit extends Cubit<ChargeStates>{
  ChargeCubit() : super(ChargeInitialState());

  static ChargeCubit get(context) => BlocProvider.of(context);

  bool created = true;
  int notId = 0;

  createNewBill({
    required String subject,
    required budget,
    required cin,
    required ddl,
    required agencyId,
    required employeeId,
    required notifType,
    required notified,
    required recursion,
  }) {
    created = false;
    emit(CreateBillLoadingState());
    BillModel model = BillModel(
      agencyId: agencyId,
      subject: subject,
      budget: budget,
      ddl: ddl,
      clientCIN: cin,
      employeeId: employeeId,
      received: notified,
      recursion: recursion,
    );
    FirebaseFirestore.instance
        .collection('bills')
        .doc()
        .set(model.toMap())
        .then((value) {
          emit(CreateBillSuccessState());
          print('success');
          created = true;
    }).catchError((error)=> emit(CreateBillErrorState(error.toString())));
  }

}