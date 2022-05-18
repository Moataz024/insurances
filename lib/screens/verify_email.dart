import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insurances/screens/agency_home.dart';
import 'package:insurances/screens/choose_role.dart';
import 'package:insurances/screens/client_home.dart';
import 'package:insurances/screens/login_screen.dart';
import 'package:insurances/shared/componenets/components.dart';
import 'package:insurances/shared/componenets/constants.dart';

class VerifyEmail extends StatefulWidget {
  VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();

}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;
  Color btnColor = Colors.blue;
  bool canResendEmail = false;

  @override
  void initState() {
    user = auth.currentUser;
    if(user != null){
      user?.sendEmailVerification();
    }
    FirebaseFirestore.instance.collection('clients').get()
      .then((value) {
       value.docs.forEach((element) {
         if(element.get('email') == user!.email){
           isClient = true;
           FirebaseFirestore.instance.collection('clients').doc(element.id)
               .update({'uid' : user!.uid});
         }
       });
    });
    isClient == null ? isClient = false : null;
    timer = Timer.periodic(Duration(seconds: 3,), (timer) {
          checkEmailVerified();
    });

    super.initState();
  }

  Future sendEmailVerification() async {
    user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
    setState(() {
      canResendEmail = false;
      btnColor = Colors.grey;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      canResendEmail = true;
      btnColor = Colors.blue;
    });
    // if(user != null){
    //   await user?.sendEmailVerification();
    //   setState(() {
    //     canResendEmail = false;
    //     btnColor = Colors.grey;
    //   });
    //   await Future.delayed(Duration(seconds: 5,),(){
    //     setState(() {
    //       canResendEmail = true;
    //       btnColor = Colors.blue;
    //     });
    //
    //   });
    // }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email verification',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Text(
                'An email has been sent to ${user?.email} please verify',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: defaultButton(
              height: 45,
              color: btnColor,
                icon: Icons.email_rounded,
                text: 'RESEND EMAIL',
                action:() {
                  canResendEmail ? sendEmailVerification() : null;
                }
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: defaultButton(
                height: 40,
                color: Colors.grey,
                icon: Icons.cancel_outlined,
                text: 'CANCEL',
                fontSize: 15,
                textColor: Colors.white,
                action:() {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> loginScreen()));
                }
            ),
          ),
        ],
      ),
    );
  }
  bool confirmed = false;
  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user?.reload();
    if(user!.emailVerified){
      timer!.cancel();
      if(!isClient!){
        FirebaseFirestore.instance.collection('employees').where('email',isEqualTo: auth.currentUser!.email).get()
            .then((value) {
          value.docs.forEach((element) {
            confirmed = element.get('confirmed');
            FirebaseFirestore.instance.collection('employees').doc('${element.id}').update(
                {'uid': '${auth.currentUser!.uid}'});
          });
          confirmed ? Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AgencyHomeScreen()))
              : Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ChooseRoleScreen()));
        });
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ClientHomeScreen()));
      }
    }
  }

}
