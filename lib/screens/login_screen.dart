import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/agency_home.dart';
import 'package:insurances/screens/client_home.dart';
import 'package:insurances/screens/registration_screen.dart';
import 'package:insurances/screens/reset_password.dart';
import 'package:insurances/screens/verify_email.dart';
import 'package:insurances/shared/componenets/components.dart';
import '../shared/componenets/constants.dart';
import '../shared/cubit/login_cubit/cubit.dart';
import '../shared/cubit/login_cubit/states.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
TextEditingController? emailController = new TextEditingController();
TextEditingController? passwordController = new TextEditingController();
bool? isVisible = true;
Color? suffixColor = Colors.grey;


class _loginScreenState extends State<loginScreen> {
  @override
  void initState() {
    if(FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => InsurancesLoginCubit(),
      child: BlocConsumer<InsurancesLoginCubit,InsurancesLoginStates>(
        listener: (BuildContext context, state) async {
          if (state is InsurancesLoginErrorState ) {
            Fluttertoast.showToast(
                msg: state.error.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          };
          if (state is InsurancesLoginSuccessState) {
            await FirebaseFirestore.instance.collection('clients').get()
              .then((value) {
                value.docs.forEach((element) {
                  if(element.get('email') == FirebaseAuth.instance.currentUser!.email){
                    isClient = true;
                  }
                });
                if(isClient == null){
                  isClient = false;
                }
            });
            FirebaseAuth.instance.currentUser!.emailVerified ?
                isClient! ?
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ClientHomeScreen()))
                :
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AgencyHomeScreen()))
                :
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> VerifyEmail()));
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spacer(),
                  Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  defaultFormField(
                      submit: (value){
                        setState(() {
                          emailController?.text = value;
                        });
                        print(emailController?.text.toString());
                        print(value);
                      },
                      prefix: Icons.alternate_email,
                      controller: emailController,
                      validate: (value) {
                        if (value != null) if (value.isEmpty) {
                          return 'Email cannot be empty!';
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Email'),
                  SizedBox(
                      height: 20
                  ),
                  defaultFormField(
                      submit: (value){
                        setState(() {
                          passwordController?.text = value;
                          print(passwordController?.text.toString());
                        });
                      },
                      suffix: InsurancesLoginCubit.get(context).suffix,
                      obscureText: InsurancesLoginCubit.get(context).isPassword,
                      isClickable: true,
                      pressOnIcon: (){
                        if (isVisible!){
                          InsurancesLoginCubit.get(context).changePasswordVisibility();
                        }else{
                          setState(() {
                            isVisible = true;
                            suffixColor = Colors.grey;
                          });
                        }
                      },
                      controller: passwordController,
                      validate: (value){
                        if(value != null ) if (value.isEmpty){
                          return 'Password cannot be empty!';
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      labelText: 'Password'
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ConditionalBuilder(
                      condition: state is! InsurancesLoadingLogin,
                      builder: (context) => defaultButton(
                          text: 'LOGIN',
                          action: (){
                            if(_formKey?.currentState != null)
                            {
                              if (_formKey!.currentState!.validate()){
                                InsurancesLoginCubit.get(context).userLogin(
                                  email: emailController!.text.toString(),
                                  password: passwordController!.text.toString(),
                                );
                              }
                            }
                          }
                      ),
                      fallback: (context) => Center(
                        child: CircularProgressIndicator(),
                      )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Don\'t have an account ?'
                      ),
                      TextButton(
                        child: Text(
                            'Register'
                        ),
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>registrationScreen(),));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Forgot password ? '
                      ),
                      TextButton(
                        child: Text(
                            'Reset'
                        ),
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>ResetPasswordScreen(),));
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
