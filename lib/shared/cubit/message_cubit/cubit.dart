import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/employee_model.dart';
import 'package:insurances/model/message_model.dart';
import 'package:insurances/shared/cubit/message_cubit/states.dart';

class MessageCubit extends Cubit<MessageStates>{
  MessageCubit() : super(MessageInitialState());

  static MessageCubit get(context) => BlocProvider.of(context);

  EmployeeModel empModel = new EmployeeModel();
  void getEmployeeByUid() {
    emit(GetEmployeeLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        empModel = EmployeeModel.fromJson(element.data());
      });
      emit(GetEmployeeSuccessState());
      print(empModel.fullName);
    }).catchError((error)=> emit(GetEmployeeErrorState(error.toString())));
  }

  void sendMessage({
  required String message,
    required String dateTime,
}){
    MessageModel model = new MessageModel(
      message: message,
      senderId: empModel.uid,
      agencyId: empModel.agencyId,
      sender: empModel.fullName,
      dateTime: dateTime,
    );
    emit(SendMessageLoadingState());
    FirebaseFirestore.instance
    .collection('chat')
    .add(model.toMap())
    .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {emit(SendMessageErrorState(error.toString()));});
  }

  List<MessageModel> messages = [];
  MessageModel message = new MessageModel();

  Future<void> getMessages() async {
    emit(GetEmployeeLoadingState());
    await FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((value) {
       empModel = EmployeeModel.fromJson(value.docs.elementAt(0).data());
       emit(GetEmployeeSuccessState());
    });
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      FirebaseFirestore.instance
          .collection('chat')
          .orderBy('dateTime',descending: true)
          .where('agencyId',isEqualTo: value.docs.elementAt(0).get('agencyId'))
          .snapshots()
          .listen((event) {
            messages = [];
        event.docs.forEach((element) {
          message = MessageModel.fromJson(element.data());
          messages.add(MessageModel.fromJson(element.data()));
        });
      });
    });
  }

}