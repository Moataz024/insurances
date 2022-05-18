import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insurances/notification_api.dart';
import 'package:insurances/screens/agency_home.dart';
import 'package:insurances/screens/agency_layouts/create_employee.dart';
import 'package:insurances/screens/chat_screen.dart';
import 'package:insurances/screens/client_home.dart';
import 'package:insurances/screens/login_screen.dart';
import 'package:insurances/screens/phone_login.dart';
import 'package:insurances/screens/registration_screen.dart';
import 'package:insurances/shared/BlockOberserver.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext myAppContext) {
      return MaterialApp(
      theme: ThemeData(
        brightness: lightTheme ? Brightness.light : Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null ? isClient == null ?  AgencyHomeScreen() : isClient! ? ClientHomeScreen() : AgencyHomeScreen() : loginScreen(),
    );
  }
}
