import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/agency_layouts/home_layout.dart';
import 'package:insurances/screens/agency_layouts/profile_layout.dart';
import 'package:insurances/screens/agency_layouts/settings_layout.dart';
import 'package:insurances/screens/agency_layouts/user_account.dart';
import 'package:insurances/shared/cubit/app_cubit/states.dart';

import '../../../model/employee_model.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens =
      [
        ResponsibleHomeScreen(),
        EmployeeProfileScreen(),
        UserAccountScreen(),
        SettingsScreen(),
      ];

  List<String> titles =
      [
        'Home',
        'Team',
        'My account',
        'Settings',
      ];

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      label: 'Home',
        icon: Icon(Icons.home)
    ),
    BottomNavigationBarItem(
      label: 'Team',
        icon: Icon(Icons.person_outline)
    ),
    BottomNavigationBarItem(
      label: 'Settings',
        icon: Icon(Icons.settings)
    ),

  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }


}