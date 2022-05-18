import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/client_model.dart';
import '../../../model/employee_model.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  EmployeeModel empModel = EmployeeModel();
  var employeeId;
  void getEmployeeByUid() {
    emit(GetEmployeeLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        empModel = EmployeeModel.fromJson(element.data());
      });
      emit(GetEmployeeSuccessState());
    }).catchError((error)=> emit(GetEmployeeErrorState(error.toString())));
  }

  ClientModel clientModel = new ClientModel();
  List<ClientModel> clients = [];
  void getClients() {
    clients = [];
    emit(GetClientsLoadingState());
    emit(GetEmployeeLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        empModel = EmployeeModel.fromJson(element.data());
        emit(GetEmployeeSuccessState());
      });
      FirebaseFirestore.instance.collection('clients')
          .where('agencyId',isEqualTo: empModel.agencyId).get().then((value) {
        print('data length : ${value.docs.length}');
        print(empModel.agencyId);
        value.docs.forEach((element) {
          clientModel = ClientModel.fromJson(element.data());
          clients.add(clientModel);
          if(clientModel.uid == FirebaseAuth.instance.currentUser!.uid){
            clients.removeLast();
          }
          print('clients : ${clients.length}');
          emit(GetClientsSuccessState());
        });
        emit(GetEmployeeSuccessState());
      });
    }).catchError((error)=> emit(GetEmployeeErrorState(error.toString())));
  }


  void deleteClient({
  required cin,
}){
    emit(DeleteLoadingState());
    FirebaseFirestore.instance.collection('clients').where('cin',isEqualTo: cin).get().then((value) {
      value.docs.forEach((element) {
          FirebaseFirestore.instance.collection('clients').doc(element.id).delete();
      });
    });
    emit(DeleteSuccessState());
  }


}