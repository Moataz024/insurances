import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/home_screen.dart';
import 'package:insurances/screens/verify_email.dart';

import '../shared/componenets/components.dart';
import '../shared/cubit/register_cubit/cubit.dart';
import '../shared/cubit/register_cubit/states.dart';

class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({Key? key}) : super(key: key);

  @override
  _ClientRegisterScreenState createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {


  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

  TextEditingController? nameController = new TextEditingController();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? cinController = new TextEditingController();
  TextEditingController? phoneController = new TextEditingController();
  TextEditingController? confirmPasswordController = new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => InsurancesRegisterCubit(),
      child: BlocConsumer<InsurancesRegisterCubit,InsurancesRegisterStates>(
        listener: (BuildContext context, Object? state) {
          if(state is InsurancesUserCreationSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=> HomeScreen()),ModalRoute.withName('/home_screen'));
          }
          if(state is InsurancesUserCreationErrorState){
            Fluttertoast.showToast(
                msg: state.error.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
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
                        'Register as a client to browse the insurances and services',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      divider(),
                      SizedBox(height: 10,),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              cinController?.text = value;
                            });
                          },
                          prefix: Icons.perm_identity_sharp,
                          controller: cinController,
                          validate: (value){
                            if(value != null){
                              if (value.isEmpty){
                                return 'Identity number cannot be empty';
                              }
                            }
                          },
                          keyboardType: TextInputType.text,
                          labelText: 'Identity number (CIN)'
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              nameController?.text = value;
                              print(nameController?.text.toString());
                            });
                          },
                          prefix: Icons.short_text_outlined,
                          controller: nameController,
                          validate: (value){
                            if (value != null ){
                              if(value.isEmpty)
                                return 'Name cannot be empty';
                            }
                          },
                          keyboardType: TextInputType.text,
                          labelText: 'Full name'
                      ),
                      SizedBox(height: 10,),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              phoneController?.text = value;
                            });
                          },
                          prefix: Icons.phone_android_rounded,
                          controller: phoneController,
                          validate: (value){
                            if(value != null){
                              if (value.isEmpty){
                                return 'Phone number cannot be empty';
                              }
                            }
                          },
                          keyboardType: TextInputType.text,
                          labelText: 'Phone number'
                      ),
                      SizedBox(height: 30,),
                      divider(),
                      ConditionalBuilder(
                          condition: state is! InsurancesUserCreationLoadingState,
                          builder: (context) => defaultButton(
                              text: 'REGISTER',
                              action: (){
                                if (_formKey?.currentState != null)
                                  if (_formKey!.currentState!.validate()){
                                    InsurancesRegisterCubit.get(context).clientCreate(
                                      fullName: nameController!.text.toString(),
                                      email: FirebaseAuth.instance.currentUser!.email.toString(),
                                      uid: FirebaseAuth.instance.currentUser!.uid.toString(),
                                      cin: cinController!.text.toString(),
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
