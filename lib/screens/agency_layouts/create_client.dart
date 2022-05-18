import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/screeens_cubits/client_create_cubit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../model/client_model.dart';
import '../../shared/componenets/components.dart';
import '../../shared/cubit/screeens_cubits/client_create_states.dart';

class CreateNewClientScreen extends StatefulWidget {
  final agencyId;
  final update;
  ClientModel? client;
  CreateNewClientScreen({Key? key, required this.agencyId,required this.update,this.client})
      : super(key: key);

  @override
  _CreateNewClientScreenState createState() => _CreateNewClientScreenState();
}

class _CreateNewClientScreenState extends State<CreateNewClientScreen> {
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  GlobalKey<FormState>? _formKey2 = GlobalKey<FormState>();

  TextEditingController? nameController = new TextEditingController();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? cinController = new TextEditingController();
  TextEditingController? phoneController = new TextEditingController();
  TextEditingController? confirmPasswordController =
      new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => CreateClientCubit()..getCurrentEmail(),
      child: BlocConsumer<CreateClientCubit, CreateClientStates>(
        listener: (BuildContext context, state) async {

          if (state is RegisterClientSuccessState) {

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
                        obscureText: CreateClientCubit.get(context).isPassword,
                        isClickable: true,
                        pressOnIcon: (){
                          CreateClientCubit.get(context).changePasswordVisibility();
                        },
                        suffix: CreateClientCubit.get(context).suffix,
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
                                  email: CreateClientCubit.get(context).currEmail,
                                  password: passwordController!.text.toString(),
                                ).then((value) {
                                  print(CreateClientCubit.get(context).currEmail);
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
                  content: Text(
                      "Now the client can login with his Email (after verification) and Identity number (CIN) as a password "),
                );
              },
            );
          }
        },
        builder: (BuildContext context, Object? state) => Scaffold(
          appBar: AppBar(
            backgroundColor: lightTheme ? Colors.blueAccent : Colors.blueGrey,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.update ? 'Update client' : 'Create new client',
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
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        submit: (value) {
                          setState(() {
                            nameController?.text = value;
                          });
                        },
                        prefix: Icons.short_text_rounded,
                        controller: nameController,
                        validate: (value) {
                          if (value != null) {
                            if (value.isEmpty)
                              return (widget.update? 'Please retype existing value if you\'re not going to update':'Full name cannot be empty');
                          }
                        },
                        keyboardType: TextInputType.text,
                        labelText: widget.update ? '${widget.client!.fullName}':'Full name'),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        submit: (value) {
                          setState(() {
                            phoneController?.text = value;
                          });
                        },
                        prefix: Icons.phone,
                        controller: phoneController,
                        validate: (value) {
                          if (value != null) {
                            if (value.isEmpty)
                              return (widget.update? 'Please retype existing value if you\'re not going to update':'Phone number cannot be empty');
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelText: widget.update ? '${widget.client?.phone}':'Phone number'),
                    SizedBox(
                      height: 10,
                    ),
                    !widget.update ?
                    defaultFormField(
                        submit: (value) {
                          setState(() {
                            cinController?.text = value;
                          });
                        },
                        prefix: Icons.perm_identity_sharp,
                        controller: cinController,
                        validate: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return widget.update? 'Please retype existing value if you\'re not going to update': 'Identity number cannot be empty';
                            }
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelText: widget.update ? '${widget.client?.cin}':'Identity number (CIN)')
                    : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        submit: (value) {
                          setState(() {
                            emailController?.text = value;
                          });
                        },
                        prefix: Icons.alternate_email_rounded,
                        controller: emailController,
                        validate: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return widget.update? 'Please retype existing value if you\'re not going to update':'Email address cannot be empty';
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        labelText: widget.update ? '${widget.client?.email}':'Email address'),
                    SizedBox(
                      height: 40,
                    ),
                    divider(),
                    ConditionalBuilder(
                        condition: widget.update? state is! UpdateClientLoadingState : state is! CreateClientSuccessState,
                        builder: (context) => defaultButton(
                            text: widget.update? 'UPDATE':'CREATE',
                            icon: widget.update ? Icons.update:Icons.add,
                            action: () {
                              if (_formKey?.currentState != null) if (_formKey!
                                  .currentState!
                                  .validate()) {
                                ClientModel model = new ClientModel(
                                  uid: widget.client?.uid,
                                  fullName: nameController!.text.toString(),
                                  email: emailController!.text.toString(),
                                  cin: widget.client?.cin,
                                  phone: phoneController!.text.toString(),
                                  agencyId: widget.agencyId,
                                  accepted: widget.client?.accepted,
                                  isClient: true,
                                );
                                // widget.update ?
                                //     CreateClientCubit.get(context).updateClient(newClientModel: model)
                                //     :

                                        CreateClientCubit.get(context)
                                                .createNewClient(
                                              agencyId: widget.agencyId,
                                              name: nameController!.text
                                                  .toString(),
                                              email: emailController!.text
                                                  .toString(),
                                              cin: cinController!.text
                                                  .toString(),
                                              phone: phoneController!.text
                                                  .toString(),
                                              accepted: true,
                                              isClient: true,
                                              password: cinController!.text
                                                  .toString(),
                                );

                                nameController!.text = '';
                                emailController!.text = '';
                                cinController!.text = '';
                                phoneController!.text = '';
                              }
                            }),
                        fallback: (context) => Center(
                              child: CircularProgressIndicator(),
                            )),
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
