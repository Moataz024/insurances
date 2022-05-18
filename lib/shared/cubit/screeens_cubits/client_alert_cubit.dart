import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'client_alert_states.dart';

class ClientAlertCubit extends Cubit<ClientAlertStates>{
  ClientAlertCubit() : super(ClientAlertInitialState());

  static ClientAlertCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ClientAlertChangePasswordVisibility());
  }
  var currEmail;
  void getCurrentEmail(){
    currEmail = FirebaseAuth.instance.currentUser!.email;
    print(currEmail);
    emit(CurrentEmailState());
  }
}