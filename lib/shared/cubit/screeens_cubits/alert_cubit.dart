import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'alert_states.dart';

class AlertCubit extends Cubit<AlertStates>{
  AlertCubit() : super(AlertInitialState());

  static AlertCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AlertChangePasswordVisibility());
  }
}