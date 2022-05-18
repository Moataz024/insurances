import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/choose_role.dart';
import 'package:insurances/screens/home_screen.dart';
import 'package:insurances/screens/verify_email.dart';
import 'package:insurances/shared/componenets/components.dart';
import '../shared/cubit/agency_cubit/cubit.dart';
import '../shared/cubit/register_cubit/cubit.dart';
import '../shared/cubit/register_cubit/states.dart';

class registrationScreen extends StatefulWidget {
  const registrationScreen({Key? key}) : super(key: key);

  @override
  _registrationScreenState createState() => _registrationScreenState();
}
GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

TextEditingController? nameController = new TextEditingController();
TextEditingController? emailController = new TextEditingController();
TextEditingController? addressController = new TextEditingController();
TextEditingController? phoneController = new TextEditingController();
TextEditingController? confirmPasswordController = new TextEditingController();
TextEditingController? passwordController = new TextEditingController();



class _registrationScreenState extends State<registrationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => InsurancesRegisterCubit(),
      child: BlocConsumer<InsurancesRegisterCubit,InsurancesRegisterStates>(
        listener: (BuildContext context, Object? state) {
          if(state is InsurancesRegisterInitialState){
            FirebaseFirestore.instance.collection('agencies')
                .where("responsibleId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
                .then((value) {
              value.docs.forEach((element) {
                print(element.reference.get());
              });
            });
          }
          if(state is InsurancesRegisterSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => VerifyEmail()),ModalRoute.withName('/verify_email'),);
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      divider(),
                      SizedBox(
                        height: 40,
                      ),
                      // defaultFormField(
                      //     submit: (value){
                      //       setState(() {
                      //         nameController?.text = value;
                      //         print(nameController?.text.toString());
                      //       });
                      //     },
                      //     prefix: Icons.perm_identity_rounded,
                      //     controller: nameController,
                      //     validate: (value){
                      //       if (value != null ){
                      //         if(value.isEmpty)
                      //           return 'Name cannot be empty';
                      //       }
                      //     },
                      //     keyboardType: TextInputType.text,
                      //     labelText: 'Full name'
                      // ),
                      SizedBox(height: 10,),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              emailController?.text = value;
                            });
                          },
                          prefix: Icons.alternate_email,
                          controller: emailController,
                          validate: (value){
                            if (value != null ){
                              if(value.isEmpty)
                                return('Email cannot be empty');
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'Email'
                      ),
                      SizedBox(height: 10,),
                      // defaultFormField(
                      //     submit: (value){
                      //       setState(() {
                      //         phoneController?.text = value;
                      //       });
                      //     },
                      //     prefix: Icons.phone_android_rounded,
                      //     controller: phoneController,
                      //     validate: (value){
                      //       if(value != null){
                      //         if (value.isEmpty){
                      //           return 'Phone number cannot be empty';
                      //         }
                      //       }
                      //     },
                      //     keyboardType: TextInputType.text,
                      //     labelText: 'Phone number'
                      // ),
                      // SizedBox(height: 10,),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              passwordController?.text = value;
                            });
                          },
                          obscureText: InsurancesRegisterCubit.get(context).isPassword,
                          isClickable: true,
                          onTap: (){

                          },
                          pressOnIcon: (){
                            InsurancesRegisterCubit.get(context).chancePasswordVisibility();
                          },
                          suffix: InsurancesRegisterCubit.get(context).suffix,
                          controller: passwordController,
                          validate: (value){
                            if(value != null)
                              if(value.isEmpty)
                                return('Password cannot be empty');
                              else if(value.length < 6){
                                return 'Password must be atleast 6 caracters';
                              }
                          },
                          keyboardType: TextInputType.text,
                          labelText: 'Password'
                      ),
                      SizedBox(height: 10,),
                      defaultFormField(
                          submit : (value){
                            setState(() {
                              confirmPasswordController?.text = value;
                            });
                          },
                          obscureText: InsurancesRegisterCubit.get(context).isPassword,
                          isClickable: true,
                          pressOnIcon: (){
                            InsurancesRegisterCubit.get(context).chancePasswordVisibility();
                          },
                          suffix: InsurancesRegisterCubit.get(context).suffix,
                          controller: confirmPasswordController,
                          validate: (value){
                            if(value != null ){
                              if(value.isEmpty)
                              return 'This field cannot be empty';
                            }if(value != passwordController!.text)
                              {
                                return 'Not matching';
                              }
                          },
                          keyboardType: TextInputType.text,
                          labelText: 'Confirm password'
                      ),
                      SizedBox(height: 30,),
                      divider(),
                      ConditionalBuilder(
                          condition: state is! InsurancesLoadingRegisterState,
                          builder: (context) => defaultButton(
                              text: 'REGISTER',
                              action: (){
                                if (_formKey?.currentState != null)
                                  if (_formKey!.currentState!.validate()){
                                    InsurancesRegisterCubit.get(context).userRegister(
                                        fullName: nameController!.text.toString(),
                                        email: emailController!.text.toString(),
                                        password: passwordController!.text.toString(),
                                        phone: phoneController!.text.toString(),
                                    );
                                  }
                              }),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator(),)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
