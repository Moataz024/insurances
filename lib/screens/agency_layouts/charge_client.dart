import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/screeens_cubits/charge_cubit.dart';
import 'package:insurances/shared/cubit/screeens_cubits/charge_states.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../notification_api.dart';
import '../../shared/componenets/components.dart';

class ChargeClientScreen extends StatefulWidget {
  final clientCIN;
  final employeeId;
  final agencyId;
  const ChargeClientScreen({Key? key,this.clientCIN,this.employeeId,this.agencyId}) : super(key: key);

  @override
  _ChargeClientScreenState createState() => _ChargeClientScreenState();
}

class _ChargeClientScreenState extends State<ChargeClientScreen> {

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }
  var dropDownValue = notificationType[0];
  int notId = 1;
  int seconds = 5;
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  int selectedIndex = 0;
  TextEditingController? subjectController = new TextEditingController();
  TextEditingController? emailController = new TextEditingController();
  TextEditingController? ddlController = new TextEditingController();
  TextEditingController? budgetController = new TextEditingController();
  TextEditingController? confirmPasswordController =
  new TextEditingController();
  TextEditingController? passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChargeCubit>(
      create: (BuildContext context) => ChargeCubit(),
      child: BlocConsumer<ChargeCubit,ChargeStates>(
        listener: (BuildContext context, Object? state) {  },
        builder: (BuildContext context, state) => Scaffold(
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
                      'Charge client',
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
                            subjectController?.text = value;
                          });
                        },
                        prefix: Icons.short_text_rounded,
                        controller: subjectController,
                        validate: (value) {
                          if (value != null) {
                            if (value.isEmpty)
                              return ('Title cannot be empty');
                          }
                        },
                        keyboardType: TextInputType.text,
                        labelText: 'Title'),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        submit: (value) {
                          setState(() {
                            budgetController?.text = value;
                          });
                        },
                        prefix: Icons.price_change_outlined,
                        controller: budgetController,
                        validate: (value) {
                          if (value != null) {
                            if (value.isEmpty)
                              return ('Fee cannot be empty');
                          }
                        },
                        keyboardType: TextInputType.number,
                        labelText: 'Bill fee'),
                    SizedBox(height: 10,),
                FlutterToggleTab(
                  width: 80,
                  borderRadius: 15,
                  selectedIndex:selectedIndex,
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  labels: ["Once","Recurring"],
                  icons: [Icons.repeat_one,Icons.event_repeat],
                  selectedLabelIndex: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                    print("Selected Index $index");
                  },
                ),
                    SizedBox(
                      height: 10,
                    ),
                selectedIndex == 0 ?


                    Container()
                    :
                DropdownButton<String>(
                  isExpanded: true,
                  value: dropDownValue,
                  icon: const Icon(Icons.arrow_downward,
                    color: Colors.grey,),
                  elevation: 10,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  underline: Container(
                    height: 2,
                    width: 50,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) => {
                  setState(() {
                  dropDownValue = newValue!;
                  if(newValue == 'Once'){
                    seconds = 5;
                  }
                  if(newValue == 'Daily'){
                    seconds = 86400;
                  }
                  if(newValue == 'Weekly'){
                    seconds = 604800;
                  }
                  if(newValue == 'Monthly'){
                    seconds = 2419200;
                  }
                  }),
                  },
                  items: notificationType
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(value,
                              textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                    SizedBox(height: 10,),
                    defaultFormField(
                      controller: ddlController,
                      validate: (value) {
                        if (value != null) if (value.isEmpty) {
                          return 'Deadline cannot be empty!';
                        }
                      },

                      //TODO : Rappel RDV

                      keyboardType: TextInputType.datetime,
                      labelText: 'Deadline',
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.parse('2030-03-27'),
                        ).then((value) {
                          if (value != null)
                            ddlController?.text =
                                value.year.toString() +
                                    '/' +
                                    value.month.toString() +
                                    '/' +
                                    value.day.toString();
                          print(value.toString());
                        });
                      },
                      prefix: Icons.date_range,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    divider(),
                    ConditionalBuilder(
                        condition: ChargeCubit.get(context).created,
                        builder: (context) => defaultButton(
                            text: 'CREATE',
                            icon: Icons.add,
                            action: () {
                              if (_formKey?.currentState != null) if (_formKey!
                                  .currentState!
                                  .validate()) {
                                ChargeCubit.get(context).createNewBill(
                                    subject: subjectController!.text,
                                    budget: budgetController!.text,
                                    cin: widget.clientCIN,
                                    ddl: ddlController!.text,
                                    agencyId: widget.agencyId,
                                    employeeId: widget.employeeId,
                                    notifType: dropDownValue,
                                    notified: false,
                                    recursion: seconds,
                                );
                                notId++;
                                // NotificationService().showNotification(
                                //   notId,
                                //   'Facturation d\'assurance',
                                //   '${seconds}Vous avez une facture a payer d\'un mantant de : ${budgetController!.text} avant le ${ddlController!.text}',
                                //     1
                                // );
                                NotificationService().showNotification(
                                    notId,
                                    'Client will receive a notification',
                                    'The client notification will repeat ${dropDownValue}',
                                    5
                                );
                                Timer(Duration(seconds: 9), () {
                                  NotificationService().cancelAllNotifications();
                                  NotificationService().showNotification(
                                      notId,
                                      'Facturation d\'assurance',
                                      '${seconds}Vous avez une facture a payer d\'un mantant de : ${budgetController!.text} avant le ${ddlController!.text}',
                                      seconds
                                  );
                                });

                                //Real action
                                subjectController!.text = '';
                                ddlController!.text = '';
                                budgetController!.text = '';
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
