import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/agency_layouts/profile_layout.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/screeens_cubits/create_cubit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../shared/componenets/components.dart';
import '../../shared/cubit/screeens_cubits/create_states.dart';

class CreateEmployeeScreen extends StatefulWidget {

  CreateEmployeeScreen({Key? key}) : super(key: key);
  @override
  _CreateEmployeeScreenState createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {


  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  GlobalKey<FormState>? _formKey2 = GlobalKey<FormState>();

  TextEditingController? nameController = new TextEditingController();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? cinController = new TextEditingController();
  TextEditingController? phoneController = new TextEditingController();
  TextEditingController? confirmPasswordController = new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CreateEmployeeCubit()..getCurrentEmail(),
      child: BlocConsumer<CreateEmployeeCubit,CreateEmployeeStates>(
        builder: (BuildContext context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text('Create new team member',
              ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Create new member',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                            phoneController?.text = value;
                          });
                        },
                        prefix: Icons.phone,
                        controller: phoneController,
                        validate: (value){
                          if (value != null ){
                            if(value.isEmpty)
                              return('Phone number cannot be empty');
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelText: 'Phone number'
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
                            emailController?.text = value;
                          });
                        },
                        prefix: Icons.alternate_email_rounded,
                        controller: emailController,
                        validate: (value){
                          if(value != null){
                            if (value.isEmpty){
                              return 'Email address cannot be empty';
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Email address'
                    ),
                    SizedBox(height: 40,),
                    divider(),
                    ConditionalBuilder(
                        condition: state is! CreateEmployeeSuccessState,
                        builder: (context) => defaultButton(
                            text: 'CREATE',
                            icon: Icons.add,
                            action: (){
                              if (_formKey?.currentState != null)
                                if (_formKey!.currentState!.validate()){
                                  CreateEmployeeCubit.get(context).createNewEmployee(
                                    name: nameController!.text.toString(),
                                    email: emailController!.text.toString(),
                                    cin: cinController!.text.toString(),
                                    phone: phoneController!.text.toString(),
                                    responsible: false,
                                    accepted: true,
                                    confirmed: true,
                                    password: cinController!.text.toString(),
                                  );
                                  nameController!.text =  '';
                                  emailController!.text =  '';
                                  cinController!.text =  '';
                                  phoneController!.text =  '';
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
        listener: (BuildContext context, Object? state) async  {
          if(state is GetCurrentEmailState){
            print(CreateEmployeeCubit.get(context).currEmail);
          }

          if(state is RegisterEmployeeSuccessState) {
            await Alert(
              buttons: [

              ],
                context: context,
                title: "Retype password",
                content: Form(
                  key: _formKey2,
                  child: Column(
                    children: <Widget>[
                      defaultFormField(
                          submit: (value){
                            setState(() {
                              passwordController?.text = value;
                            });
                          },
                          obscureText: CreateEmployeeCubit.get(context).isPassword,
                          isClickable: true,
                          pressOnIcon: (){
                            CreateEmployeeCubit.get(context).changePasswordVisibility();
                          },
                          suffix: CreateEmployeeCubit.get(context).suffix,
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
                      SizedBox(height: 20,),
                      defaultButton(
                        width: 200,
                          text: 'Confirm',
                          action: (){
                            if(_formKey2?.currentState != null)
                            {
                              if (_formKey2!.currentState!.validate()){
                                FirebaseAuth.instance.signOut().then((value) {
                                  FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: CreateEmployeeCubit.get(context).currEmail,
                                      password: passwordController!.text.toString(),
                                  ).then((value) {
                                    print(CreateEmployeeCubit.get(context).currEmail);
                                    print(value.user!.email);

                                    Navigator.pop(context);
                                  }).catchError((error) => {
                            showToast
                              (
                              bgColor: Colors.redAccent,
                              gravity: ToastGravity.BOTTOM,
                              message: '${error.toString}'
                            )});
                                });
                              }
                            }
                          }),
                    ],
                  ),
                ),
                ).show();
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Successfully created"),
                  content: Text("Now member can login with his Email and Identity number (CIN) as a password"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
