import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/emp_agency_exists_cubit/states.dart';

import '../../../model/employee_model.dart';

class EmpCubit extends Cubit<EmpStates> {
  EmpCubit() : super(EmpInitialState());

  static EmpCubit get(context) => BlocProvider.of(context);


  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  String? aid;

  void employeeRegister({
    required String name,
    required String email,
    required String phone,
    required String cin,
    required bool responsible,
    required bool confirmed,
    required String agencyId,
  }) {
      EmployeeModel model = EmployeeModel(
        agencyId: agencyId,
        fullName: name,
        email: email,
        phone: phone,
        cin: cin,
        responsible: responsible,
        uid: FirebaseAuth.instance.currentUser?.uid,
      );
      emit(CreateEmployeeLoadingState());
      FirebaseFirestore.instance
          .collection('employees')
          .doc().set(model.toMap()).then((value) {
        emit(CreateEmployeeSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(CreateEmployeeErrorState(error.toString()));
      });
  }
}
