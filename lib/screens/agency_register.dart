import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/employee_register.dart';
import 'package:insurances/screens/verify_email.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/register_cubit/states.dart';

import '../shared/componenets/components.dart';
import '../shared/cubit/register_cubit/cubit.dart';

class AgencyRegisterScreen extends StatefulWidget {
  const AgencyRegisterScreen({Key? key}) : super(key: key);

  @override
  _AgencyRegisterScreenState createState() => _AgencyRegisterScreenState();
}

class _AgencyRegisterScreenState extends State<AgencyRegisterScreen> {

  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

  TextEditingController? nameController = new TextEditingController();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? addressController = new TextEditingController();
  TextEditingController? phoneController = new TextEditingController();
  TextEditingController? confirmPasswordController = new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => InsurancesRegisterCubit(),
      child: BlocConsumer<InsurancesRegisterCubit,InsurancesRegisterStates>(
        listener: (BuildContext context, Object? state) {
          if(state is InsurancesAgencyCreationSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EmployeeRegisterScreen()),ModalRoute.withName('/employee_register'),);
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: lightTheme ? Colors.blueAccent : Colors.blueGrey,
              title: Center(
                child: Text(
                  'Register'
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please fill in your agency information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      divider(),
                      SizedBox(
                        height: 40,
                      ),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              nameController?.text = value;
                              print(nameController?.text.toString());
                            });
                          },
                          prefix: Icons.perm_identity_rounded,
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
                              emailController?.text = value;
                            });
                          },
                          prefix: Icons.quick_contacts_mail_rounded,
                          controller: emailController,
                          validate: (value){
                            if (value != null ){
                              if(value.isEmpty)
                                return('Email cannot be empty');
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'Agency contact email '
                      ),
                      SizedBox(height: 10,),
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              phoneController?.text = value;
                            });
                          },
                          prefix: Icons.phone,
                          controller: phoneController,
                          validate: (value){
                            if(value != null){
                              if (value.isEmpty){
                                return 'Phone number cannot be empty';
                              }
                            }
                          },
                          keyboardType: TextInputType.phone,
                          labelText: 'Phone number'
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: defaultDropDown(
                          context: context,
                          elev: 40,
                          items: regionsTunisie,
                        ),
                      ),
                      SizedBox(height: 30,),
                      divider(),
                      ConditionalBuilder(
                          condition: state is! InsurancesAgencyCreationLoadingState,
                          builder: (context) => defaultButton(
                              text: 'Next step',
                              icon: Icons.navigate_next,
                              action: (){
                                if (_formKey?.currentState != null)
                                  if (_formKey!.currentState!.validate()){
                                    InsurancesRegisterCubit.get(context).agencyRegister(
                                      name: nameController!.text.toString(),
                                      email: emailController!.text.toString(),
                                      contactPhone: phoneController!.text.toString(),
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
