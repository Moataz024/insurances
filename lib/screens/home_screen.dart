import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insurances/screens/verify_email.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return !FirebaseAuth.instance.currentUser!.emailVerified ? VerifyEmail() :
      Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          '${FirebaseAuth.instance.currentUser?.email.toString()}',
        ),
      ),
      body: Container(),
    );
  }
}
