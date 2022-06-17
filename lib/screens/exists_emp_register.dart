import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/emp_agency_exists_cubit/states.dart';

import '../shared/componenets/components.dart';
import '../shared/cubit/emp_agency_exists_cubit/employee_wAgency_exists_cubit.dart';

class EmployeeWithAgencyExistsRegisterScreen extends StatefulWidget {
  final agencyId;
  const EmployeeWithAgencyExistsRegisterScreen({Key? key,this.agencyId}) : super(key: key);

  @override
  _EmployeeRegisterScreenState createState() => _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState extends State<EmployeeWithAgencyExistsRegisterScreen> {
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

  TextEditingController? nameController = new TextEditingController();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? addressController = new TextEditingController();
  TextEditingController? phoneController = new TextEditingController();
  TextEditingController? confirmPasswordController = new TextEditingController();
  TextEditingController? cinController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EmpCubit(),
      child: BlocConsumer<EmpCubit,EmpStates>(
        builder: (BuildContext context, state) => Scaffold(
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
                    SizedBox(height: 10,),
                    SizedBox(height: 30,),
                    divider(),
                    ConditionalBuilder(
                        condition: state is! CreateEmployeeLoadingState,
                        builder: (context) => defaultButton(
                            text: 'FINISH',
                            icon: Icons.check,
                            action: (){
                              if (_formKey?.currentState != null)
                                if (_formKey!.currentState!.validate()){
                                  EmpCubit.get(context).employeeRegister(
                                    name: nameController!.text.toString(),
                                    email: FirebaseAuth.instance.currentUser!.email!,
                                    cin: cinController!.text.toString(),
                                    phone: phoneController!.text.toString(),
                                    responsible: false,
                                    updated: false,
                                    accepted: false,
                                    agencyId: widget.agencyId,
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
        ) ,
        listener: (BuildContext context, Object? state) {  },
      ),
    );
  }
}
