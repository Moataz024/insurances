import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/agency_model.dart';
import 'package:insurances/model/client_model.dart';
import 'package:insurances/model/employee_model.dart';
import 'package:insurances/shared/componenets/components.dart';
import 'package:insurances/shared/cubit/register_cubit/states.dart';
import 'package:intl/intl.dart';

class InsurancesRegisterCubit extends Cubit<InsurancesRegisterStates> {
  InsurancesRegisterCubit() : super(InsurancesRegisterInitialState());

  static InsurancesRegisterCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  String? value = regionsTunisie[0];
  String? aid;

  void employeeRegister({
    required String name,
    required String email,
    required String phone,
    required String cin,
    required bool responsible,
    required bool accepted,
})  {
     FirebaseFirestore.instance.collection('agencies')
        .where("responsibleId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value) {
      value.docs.forEach((element) {
        aid = element.id;
        print(element.id);
      });
    }).then((value) {
       EmployeeModel model = EmployeeModel(
         agencyId: aid,
         fullName: name,
         email : email,
         phone : phone,
         cin : cin,
         responsible: responsible,
         uid: FirebaseAuth.instance.currentUser?.uid,
         accepted: true,
         updated: false,
         confirmed: true,
       );
       emit(InsurancesEmployeeCreationLoadingState());
       FirebaseFirestore.instance
           .collection('employees')
           .doc().set(model.toMap()).then((value) {
         emit(InsurancesEmployeeCreationSuccessState());
       }).catchError((error) {
         print(error.toString());
         emit(InsurancesEmployeeCreationErrorState(error.toString()));
       });
     }).catchError((error) {
       print(error.toString());
       emit(InsurancesEmployeeCreationErrorState(error.toString()));
     });
}
  void agencyRegister({
    required String name,
    required String email,
    required String contactPhone,
}){
    DateTime now = DateTime.now();
    String formatter = DateFormat.yMMMMd().format(now);
    AgencyModel model = AgencyModel(
      name: name,
      email : email,
      contactPhone : contactPhone,
      Location : value,
      creationDate : formatter,
      responsibleId: FirebaseAuth.instance.currentUser?.uid,
    );
    emit(InsurancesAgencyCreationLoadingState());
    FirebaseFirestore.instance
        .collection('agencies').add(model.toMap()).then((value) {
          aid = value.id;
          FirebaseFirestore.instance.collection('agencies').doc('${aid}').update(
              {'agencyId': '$aid'});
      emit(InsurancesAgencyCreationSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(InsurancesAgencyCreationErrorState(error.toString()));
    });
}

  void userRegister({
  required String fullName,
  required String email,
  required String password,
  required String phone,
}){
   emit(InsurancesLoadingRegisterState());
  FirebaseAuth.instance
   .createUserWithEmailAndPassword(
      email: email,
      password: password
  ).then((value) {
  print(value.user?.email);
  print(value.user?.uid);
  emit(InsurancesRegisterSuccessState());
  }
  ).catchError((error) => emit(InsurancesRegisterErrorState(error.toString())));

  }
  void changeDropDownValue({
  required String? newValue,
}){
    value = newValue;
    emit(InsurancesChangeDropDownValueState());
  }
  void clientCreate({
    required String cin,
    required String fullName,
    required String email,
    required String uid,
    required String phone,
  }){
    ClientModel model = ClientModel(
      fullName: fullName,
      email : email,
      phone : phone,
      uid : uid,
      cin : cin,
    );
    emit(InsurancesUserCreationLoadingState());
    FirebaseFirestore.instance
        .collection('clients')
        .doc().set(model.toMap()).then((value) {
      emit(InsurancesUserCreationSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(InsurancesUserCreationErrorState(error.toString()));
    });
  }

  void chancePasswordVisibility(){

    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(InsurancesChangePasswordVisibilityState());
  }
}