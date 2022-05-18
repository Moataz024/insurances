import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/componenets/constants.dart';
import '../../../model/employee_model.dart';
import 'create_states.dart';

class CreateEmployeeCubit extends Cubit<CreateEmployeeStates> {
  CreateEmployeeCubit() : super(CreateEmployeeInitialState());

  static CreateEmployeeCubit get(context) => BlocProvider.of(context);

  var currEmail;
  void getCurrentEmail(){
    currEmail = FirebaseAuth.instance.currentUser!.email;
    print(currEmail);
    emit(GetCurrentEmailState());
  }

  String agency = '';
  createNewEmployee({
    required String name,
    required email,
    required cin,
    required phone,
    required responsible,
    required confirmed,
    required password,
  }) {
    emit(CreateEmployeeLoadingState());
    FirebaseFirestore.instance
        .collection('agencies')
        .where("responsibleId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        agency = element.id;
        print(element.id);
      });
    }).then((value) {
      EmployeeModel model = EmployeeModel(
        agencyId: agency,
        fullName: name,
        email: email,
        phone: phone,
        cin: cin,
        responsible: responsible,
        confirmed: confirmed,
      );
      FirebaseFirestore.instance
          .collection('employees')
          .doc()
          .set(model.toMap())
          .then((value) {
        userRegister(email: email, password: password);
        emit(CreateEmployeeSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(CreateEmployeeErrorState(error.toString()));
      });
    }).catchError((error) {
      print(error.toString());
      emit(CreateEmployeeErrorState(error.toString()));
    });
  }

  void userRegister({
    required String email,
    required String password,
  }) {
    emit(RegisterEmployeeLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      emit(RegisterEmployeeSuccessState());
      // FirebaseFirestore.instance.collection('employees').get()
      //   .then((value) {
      //   value.docs.forEach((element) {
      //     newModel.add(EmployeeModel.fromJson(element.data()));
      //     print(newModel[0]?.email);
      //     emit(RegisterEmployeePrintState());
      //   });
      // });
    }).catchError(
            (error) => emit(RegisterEmployeeErrorState(error.toString())));
  }

  void reSignIn({
    required currentEmail,
    required currentPassword,
  }) {
    print(currentEmail);
    emit(ReSignInLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: currentEmail, password: currentPassword)
          .then((value) {
            print(value.user!.email);
        emit(ReSignInSuccessState());
      }).catchError((error) => emit(ReSignInErrorState(error.toString())));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(CreateEmployeeChangePasswordVisibilityState());
  }
}
