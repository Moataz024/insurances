import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/employee_model.dart';
import 'package:insurances/screens/agency_layouts/home_layout.dart';
import 'package:insurances/screens/agency_layouts/profile_layout.dart';
import 'package:insurances/screens/agency_layouts/settings_layout.dart';
import 'package:insurances/shared/cubit/employee_cubit/states.dart';

import '../../componenets/components.dart';

class EmployeeCubit extends Cubit<EmployeeStates>{
  EmployeeCubit() : super(EmployeeInitialState());

  static EmployeeCubit get(context) => BlocProvider.of(context);


  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business_center_outlined,
      ),
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.science_outlined,
          size: 25,
        )),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports_soccer_outlined,
        size: 25,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
        size: 25,
      ),
    ),
  ];

  List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.deepOrange,
    Colors.blueGrey,
  ];
  EmployeeModel model = EmployeeModel();
  var employeeId;
  void getEmployeeByUid(){
    emit(EmployeeGetLoadingState());
    FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        model = EmployeeModel.fromJson(element.data());
      });
      emit(EmployeeGetSuccessState());
    }).catchError((error)=> emit(EmployeeGetErrorState(error.toString())));
  }
  int currentIndex = 0;

  List<Widget> screens = [
    ResponsibleHomeScreen(),
    EmployeeProfileScreen(),
    SettingsScreen(),
  ];
  void changeIndex(index) {
    currentIndex = index;
    emit(EmployeeChangeBottomBarState());
  }
  
  Future<bool?> isResponsible() async {
    bool? responsible;
    await FirebaseFirestore.instance.collection('employees')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value){
      value.docs.forEach((element) {
        responsible = element.get('responsible');
      });
    });
    return responsible;
  }

}