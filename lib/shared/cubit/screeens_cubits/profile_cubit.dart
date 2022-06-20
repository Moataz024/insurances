import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/screeens_cubits/profile_states.dart';
import '../../../model/employee_model.dart';
import '../../componenets/constants.dart';

class ProfileCubit extends Cubit<ProfileStates>{
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  EmployeeModel model = EmployeeModel();
  var employeeId;
  void getEmployeeByUid() {
    emit(GetEmployeeLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        model = EmployeeModel.fromJson(element.data());
        print(model.fullName);
        print(model.uid);
      });
      emit(GetEmployeeSuccessState());
    }).catchError((error)=> emit(GetEmployeeErrorState(error.toString())));
  }

  EmployeeModel coWorkerModel = new EmployeeModel();
  List<EmployeeModel> coWorkers = [];
  bool exists = false;
  void getCoWorkers() {
    coWorkers = [];
    emit(GetEmployeeLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
          model = EmployeeModel.fromJson(element.data());
      });
      emit(CoWorkersLoadingState());
      FirebaseFirestore.instance.collection('employees')
          .where('agencyId',isEqualTo: model.agencyId).get().then((value) {
        print('data length : ${value.docs.length}');
        print(model.agencyId);
        value.docs.forEach((element) {
          if(element.get('accepted') == true){
            coWorkerModel = EmployeeModel.fromJson(element.data());
            coWorkers.add(coWorkerModel);
            if(coWorkerModel.uid == FirebaseAuth.instance.currentUser!.uid){
              coWorkers.removeLast();
            }
          }
          print('coWorkers : ${coWorkers.length}');
          print('coWorkers : ${coWorkerModel.fullName}');
          emit(CoWorkersSuccessState());
        });
        emit(GetEmployeeSuccessState());
      }).catchError((error)=> emit(CoWorkersErrorState(error.toString())));
    }).catchError((error)=> emit(GetEmployeeErrorState(error.toString())));
  }

  void deleteRecord(EmployeeModel model){
    emit(LoadingDeleteState());
    FirebaseFirestore.instance.collection('employees').where('cin', isEqualTo: model.cin).get().then((value) {
      value.docs.forEach((element) {
        if(element.get('cin')== model.cin){
          FirebaseFirestore.instance.collection('employees').doc(element.id).delete();
        }
      });
    });
    emit(SuccessDeleteState());
  }

  void init(){
    getEmployeeByUid();
    Timer(Duration(seconds: 3,), () {
      getCoWorkers();
    },);
  }
}