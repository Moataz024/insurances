import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/registration_screen.dart';
import 'package:insurances/shared/cubit/login_cubit/phone_login.dart';

import '../shared/componenets/components.dart';
import '../shared/cubit/login_cubit/phone_states.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneScreenState createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {

  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();
  bool? isVisible = true;
  Color? suffixColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PhoneLoginCubit(),
      child: BlocConsumer<PhoneLoginCubit,PhoneLoginStates>(
          listener: (BuildContext context, state) {  },
          builder: (BuildContext context, Object? state)=> Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Spacer(),
                  Center(
                    child: Text(
                      'LOGIN WITH PHONE NUMBER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  divider(),
                  SizedBox(
                    height: 50,
                  ),
                  defaultFormField(
                      submit: (value){
                        setState(() {
                          phoneController?.text = value;
                        });
                        print(phoneController?.text.toString());
                        print(value);
                      },
                      prefix: Icons.phone,
                      controller: phoneController,
                      validate: (value) {
                        if (value != null) if (value.isEmpty) {
                          return 'Phone number cannot be empty!';
                        }
                      },
                      keyboardType: TextInputType.number,
                      labelText: 'Phone number'),
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
                      suffix: PhoneLoginCubit.get(context).suffix,
                      obscureText: PhoneLoginCubit.get(context).isPassword,
                      isClickable: true,
                      pressOnIcon: (){
                        if (isVisible!){
                          PhoneLoginCubit.get(context).changePasswordVisibility();
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
                      condition: state is! LoadingPhoneLogin,
                      builder: (context) => defaultButton(
                          text: 'LOGIN',
                          action: (){
                            if(_formKey?.currentState != null)
                            {
                              if (_formKey!.currentState!.validate()){
                                PhoneLoginCubit.get(context).userLoginWithPhone(
                                  phone: phoneController!.text.toString(),
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
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  registrationScreen(),));
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
