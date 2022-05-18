import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/update_cubit/update_states.dart';

import '../../../model/employee_model.dart';

class UpdateCubit extends Cubit<UpdateStates>{
  UpdateCubit() : super(UpdateInitialState());

  static UpdateCubit get(context) => BlocProvider.of(context);

  EmployeeModel empModel = new EmployeeModel();
  var employeeId;
  void getEmployeeByUid() {
    emit(GetEmpLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        empModel = EmployeeModel.fromJson(element.data());
        emit(GetEmpSuccessState());
      });
    }).catchError((error)=> emit(GetEmpErrorState(error.toString())));
  }

  void updateData({
  required EmployeeModel newEmpModel,
}){
    emit(UpdateEmployeeLoadingState());
    FirebaseFirestore.instance.collection('employees').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value) {
       value.docs.forEach((element) {
         if(element.get('uid')== FirebaseAuth.instance.currentUser!.uid){
           if(newEmpModel != null){
             FirebaseFirestore.instance.collection('employees').doc(element.id)
                 .set(newEmpModel.toMap());
           }
         }
         emit(UpdateEmployeeSuccessState());
       });
    }).catchError((error) => emit(UpdateEmployeeErrorState(error.toString())));
  }
}