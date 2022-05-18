import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/employee_register.dart';
import 'package:insurances/screens/login_screen.dart';
import 'package:insurances/shared/componenets/components.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receive an email to \n reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) {
                  email != null ? 'Email can\'t be null' : null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () => resetPassword(emailController.text,context),
                  icon: Icon(Icons.email),
                  label: Text(
                    'Reset password',
                    style: TextStyle(fontSize: 24),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Future resetPassword(String email,context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Navigator.of(context).popUntil((route) => route.isFirst);
    showToast(message: 'Reset password email has been sent to ${email}');
  }on FirebaseAuthException catch(e){
    print(e);
    showToast(
      message: e.message.toString(),
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.pop(context);
  }
}
