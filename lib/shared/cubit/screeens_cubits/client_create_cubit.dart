import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/client_model.dart';
import 'client_create_states.dart';

class CreateClientCubit extends Cubit<CreateClientStates> {
  CreateClientCubit() : super(CreateClientInitialState());

  static CreateClientCubit get(context) => BlocProvider.of(context);

  var currEmail;
  void getCurrentEmail(){
    currEmail = FirebaseAuth.instance.currentUser!.email;
    print(currEmail);
    emit(GetCurrentEmailState());
  }

  createNewClient({
    required String name,
    required email,
    required cin,
    required phone,
    required accepted,
    required password,
    required agencyId,
    required isClient,
  }) {
    emit(CreateClientLoadingState());
      ClientModel model = ClientModel(
        agencyId: agencyId,
        fullName: name,
        email: email,
        phone: phone,
        cin: cin,
        accepted: accepted,
        isClient: isClient,
      );
      FirebaseFirestore.instance
          .collection('clients')
          .doc()
          .set(model.toMap())
          .then((value) {
        userRegister(email: email, password: password);
        emit(CreateClientSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(CreateClientErrorState(error.toString()));
      }).catchError((error) {
        print(error.toString());
        emit(CreateClientErrorState(error.toString()));;
    });
  }

  void userRegister({
    required String email,
    required String password,
  }) {
    emit(RegisterClientLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user?.email);
      print(value.user?.uid);
      emit(RegisterClientSuccessState());
    }).catchError(
            (error) => emit(RegisterClientErrorState(error.toString())));
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
    emit(CreateClientChangePasswordVisibilityState());
  }

  void updateClient({
  required ClientModel newClientModel,
}){
    emit(UpdateClientLoadingState());
    FirebaseFirestore.instance.collection('clients').where('cin',isEqualTo: newClientModel.cin).get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.get('cin')== newClientModel.cin){
          if(newClientModel != null){
            FirebaseFirestore.instance.collection('clients').doc(element.id)
                .set(newClientModel.toMap());
          }
        }
        emit(UpdateClientSuccessState());
      });
    }).catchError((error) => emit(UpdateClientErrorState(error.toString())));
  }
}
