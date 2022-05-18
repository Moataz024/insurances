import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/home_screen.dart';
import 'package:insurances/shared/cubit/agency_cubit/cubit.dart';

import '../shared/componenets/components.dart';
import '../shared/cubit/register_cubit/cubit.dart';
import '../shared/cubit/register_cubit/states.dart';
import 'agency_home.dart';

class EmployeeRegisterScreen extends StatefulWidget {
  const EmployeeRegisterScreen({Key? key}) : super(key: key);
  @override
  _EmployeeRegisterScreenState createState() => _EmployeeRegisterScreenState();
}

GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

TextEditingController? nameController = new TextEditingController();
TextEditingController? emailController = new TextEditingController();
TextEditingController? addressController = new TextEditingController();
TextEditingController? phoneController = new TextEditingController();
TextEditingController? confirmPasswordController = new TextEditingController();
TextEditingController? cinController = new TextEditingController();


class _EmployeeRegisterScreenState extends State<EmployeeRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => InsurancesRegisterCubit(),
      child: BlocConsumer<InsurancesRegisterCubit,InsurancesRegisterStates>(
        listener: (BuildContext context, state) {
      if (state is InsurancesEmployeeCreationErrorState ) {
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
          if(state is InsurancesEmployeeCreationSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AgencyHomeScreen()),ModalRoute.withName('/agency_home'),);
          }
        },
        builder: (BuildContext context, Object? state) => Scaffold(
          appBar: AppBar(
            title: Text('${FirebaseAuth.instance.currentUser?.email}'),
          ),
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
                    SizedBox(height: 10,),
                    defaultFormField(
                        submit: (value){
                          setState(() {
                            nameController?.text = value;
                          });
                        },
                        prefix: Icons.short_text_rounded,
                        controller: nameController,
                        validate: (value){
                          if (value != null ){
                            if(value.isEmpty)
                              return('Full name cannot be empty');
                          }
                        },
                        keyboardType: TextInputType.text,
                        labelText: 'Full name'
                    ),
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
                        keyboardType: TextInputType.number,
                        labelText: 'Identity number (CIN)'
                    ),
                    SizedBox(height: 10,),
                    defaultFormField(
                        submit: (value){
                          setState(() {
                            phoneController?.text = value;
                          });
                        },
                        prefix: Icons.perm_identity_sharp,
                        controller: phoneController,
                        validate: (value){
                          if(value != null){
                            if (value.isEmpty){
                              return 'Phone number cannot be empty';
                            }
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelText: 'Phone number '
                    ),
                    SizedBox(height: 10,),
                    SizedBox(height: 30,),
                    divider(),
                    ConditionalBuilder(
                        condition: state is! InsurancesEmployeeCreationLoadingState,
                        builder: (context) => defaultButton(
                            text: 'FINISH',
                            icon: Icons.check,
                            action: (){
                              if (_formKey?.currentState != null)
                                if (_formKey!.currentState!.validate()){
                                  InsurancesRegisterCubit.get(context).employeeRegister(
                                    name: nameController!.text.toString(),
                                    email: FirebaseAuth.instance.currentUser!.email!,
                                    cin: cinController!.text.toString(),
                                    phone: phoneController!.text.toString(),
                                    responsible: true,
                                    confirmed: false,
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
        ),
      ),
    );
  }
}
