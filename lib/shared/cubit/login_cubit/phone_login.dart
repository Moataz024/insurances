import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/login_cubit/phone_states.dart';
import 'package:insurances/shared/cubit/login_cubit/states.dart';

class PhoneLoginCubit extends Cubit<PhoneLoginStates> {
  PhoneLoginCubit() : super(PhoneLoginInitialState());
  static PhoneLoginCubit get(context) => BlocProvider.of(context);

  void userLoginWithPhone({
    required phone,
}){
    bool phoneVerified = false;
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+216'+phone,
        verificationCompleted: (PhoneAuthCredential){
          FirebaseAuth.instance.signInWithCredential(PhoneAuthCredential).then((value) {
            print("You are logged in successfully");
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (verificationId){});
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(PhoneLoginChangePasswordVisibilityState());
  }

}