import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/client_model.dart';
import 'package:insurances/model/employee_model.dart';
import 'package:insurances/model/meeting_model.dart';
import 'package:insurances/shared/cubit/notifications_cubit/states.dart';

class NotifCubit extends Cubit<NotifStates> {
  NotifCubit() : super(NotifInitialState());

  static NotifCubit get(context) => BlocProvider.of(context);

  EmployeeModel employeeModel = new EmployeeModel();
  String? agencyId;
  late List<EmployeeModel> memberRequests = [];
  late List<MeetingModel> appointments = [];
  late List<ClientModel> clients = [];
  void getMemberRequests() async {
    emit(LoadingState());
    await FirebaseFirestore.instance.collection('employees').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) => {
      value.docs.forEach((element) {
        if(element.get('uid') == FirebaseAuth.instance.currentUser!.uid)
          agencyId = element.get('agencyId');
      })
    });
    await FirebaseFirestore.instance
        .collection('employees')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element.get('accepted') == false)
                  if(element.get('updated') == false)
                    if(element.get('agencyId') == agencyId)
                      memberRequests.add(EmployeeModel.fromJson(element.data()));
              }),
              FirebaseFirestore.instance
                  .collection('appointments')
                  .get()
                  .then((value) => {
                        value.docs.forEach((element) async {
                          if (element.get('accepted') ==
                              false) if (element.get('canceled') == false)
                            appointments
                                .add(MeetingModel.fromJson(element.data()));
                        }),
                      })
                  .catchError((error) => emit(ErrorState(error.toString()))),
            })
        .catchError((error) => emit(ErrorState(error.toString())));
    emit(SuccessState());
  }

  void AcceptMeeting({
    required MeetingModel model,
  }) {
    emit(LoadingAcceptingMeetingState());
    FirebaseFirestore.instance
        .collection('appointments')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element.get('day') == model.day &&
                    element.get('month') == model.month &&
                    element.get('hour') == model.hour &&
                    element.get('minute') == model.minute &&
                    element.get('client') == model.client)
                  FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(element.id)
                      .update({'accepted': true, 'updated' : true});
              }),
    emit(AcceptedMeetingState())
    });
  }

  void DeclineMeeting({
    required MeetingModel model,
  }) {
    emit(LoadingDecliningMeetingState());
    FirebaseFirestore.instance
        .collection('appointments')
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element.get('day') == model.day &&
                    element.get('month') == model.month &&
                    element.get('hour') == model.hour &&
                    element.get('minute') == model.minute &&
                    element.get('client') == model.client)
                  FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(element.id)
                      .update({'canceled': true,  'updated': true});
              }),
    emit(DeclinedMeetingState())
    });
  }

  void AcceptMember({
    required EmployeeModel model,
  }) {
    emit(LoadingAcceptingMemberState());
    FirebaseFirestore.instance.collection('employees').get().then((value) => {
          value.docs.forEach((element) {
            if (model.email == element.get('email'))
              FirebaseFirestore.instance
                  .collection('employees')
                  .doc(element.id)
                  .update({'accepted': true});
          }),
    emit(AcceptedMemberState())
    });
  }

  void DeclineMember({
    required EmployeeModel model,
  }) {
    emit(LoadingDecliningMemberState());
    FirebaseFirestore.instance.collection('employees').get().then((value) => {
          value.docs.forEach((element) {
            if (model.email == element.get('email'))
              FirebaseFirestore.instance
                  .collection('employees')
                  .doc(element.id)
                  .update({'accepted': false,'updated' : true});
          }),
    emit(DeclinedMemberState())
    });
  }
}
