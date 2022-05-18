import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/login_cubit/states.dart';

class InsurancesLoginCubit extends Cubit<InsurancesLoginStates> {
  InsurancesLoginCubit() : super(InsurancesLoginInitialState());
  static InsurancesLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
  required email,
    required password,
}){
    emit(InsurancesLoadingLogin());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      print(value.user?.uid);
      print(value.user?.email);
      emit(InsurancesLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(InsurancesLoginErrorState(error.toString()));
      }
      );

  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;
    emit(InsurancesChangePasswordVisibilityState());
  }

}