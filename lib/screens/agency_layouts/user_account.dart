import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/agency_home.dart';
import 'package:insurances/shared/componenets/components.dart';
import 'package:insurances/shared/cubit/update_cubit/update_cubit.dart';
import 'package:insurances/shared/cubit/update_cubit/update_states.dart';

import '../../model/employee_model.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
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
      create: (BuildContext context) => UpdateCubit()..getEmployeeByUid(),
      child: BlocConsumer<UpdateCubit,UpdateStates>(

        listener: (BuildContext context, state) {
          if(state is UpdateEmployeeSuccessState){
            showToast(message: 'Updated successfully',
            gravity: ToastGravity.BOTTOM);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=> AgencyHomeScreen()));
          }
        },
        builder: (BuildContext context, Object? state) => ConditionalBuilder(
          fallback: (BuildContext context) => LinearProgressIndicator(),
          condition: state is! GetEmpLoadingState,
          builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'My info',
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
                                  return('Please retype old value if you\'re not gonna update');
                              }
                            },
                            keyboardType: TextInputType.text,
                            labelText: '${UpdateCubit.get(context).empModel.fullName}'
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
                                  return 'Please retype old value if you\'re not gonna update';
                                }
                              }
                            },
                            keyboardType: TextInputType.number,
                            labelText: '${UpdateCubit.get(context).empModel.cin}'
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
                                  return 'Please retype old value if you\'re not gonna update';
                                }
                              }
                            },
                            keyboardType: TextInputType.number,
                            labelText: '${UpdateCubit.get(context).empModel.phone}'
                        ),
                        SizedBox(height: 10,),
                        SizedBox(height: 30,),
                        divider(),
                        ConditionalBuilder(
                            condition: state is! UpdateEmployeeLoadingState,
                            builder: (context) => defaultButton(
                                text: 'UPDATE',
                                icon: Icons.update,
                                action: (){
                                  if (_formKey?.currentState != null)
                                    if (_formKey!.currentState!.validate()){
                                      EmployeeModel newModel = new EmployeeModel(
                                        agencyId: UpdateCubit.get(context).empModel.agencyId,
                                        confirmed: UpdateCubit.get(context).empModel.confirmed,
                                        responsible: UpdateCubit.get(context).empModel.responsible,
                                        fullName: nameController!.text,
                                        phone: phoneController!.text,
                                        cin: cinController!.text,
                                        email: UpdateCubit.get(context).empModel.email,
                                        teamId: UpdateCubit.get(context).empModel.teamId,
                                        uid: UpdateCubit.get(context).empModel.uid,
                                      );
                                      UpdateCubit.get(context).updateData(newEmpModel: newModel);
                                    }
                                }),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator(),)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
