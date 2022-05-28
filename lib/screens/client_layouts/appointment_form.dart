import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/appointment_cubit/appoint_cubit.dart';
import 'package:insurances/shared/cubit/appointment_cubit/appoint_states.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../shared/componenets/components.dart';

class AppointmentFormScreen extends StatefulWidget {
  final client;
  final agency;
  const AppointmentFormScreen({Key? key,this.client,this.agency}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<AppointmentFormScreen> {
  @override
  void initState() {
   setState(() {
     buttonState = ButtonState.idle;
   });
      super.initState();
  }
  TextEditingController startDateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController subjectController = new TextEditingController();
  DateTime? start;
  DateTime? startTime;
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  var buttonState = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppointmentCubit(),
      child: BlocConsumer<AppointmentCubit,AppointmentStates>(
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: AppBar(

              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        child: Text(
                          'Please fill in the appointment information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      divider(),

                      SizedBox(height: 30,),
                      defaultFormField(
                        controller: startDateController,
                        validate: (value) {
                          if (value != null) if (value.isEmpty) {
                            return 'Deadline cannot be empty!';
                          }
                        },
                        keyboardType: TextInputType.datetime,
                        labelText: 'Start date',
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2030-03-27'),
                          ).then((value) {
                            if (value != null){
                              start = DateTime(value.year,value.month,value.day);
                              startDateController.text =
                                  value.year.toString() +
                                      '/' +
                                      value.month.toString() +
                                      '/' +
                                      value.day.toString();
                              print(value.toString());
                            }
                          });
                        },
                        prefix: Icons.date_range,
                      ),
                      SizedBox(height: 20,),
                      defaultFormField(
                        controller: timeController,
                        onTap: () {
                          showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now())
                              .then((value) {
                            print(value?.format(context));
                            if (value != null)
                              timeController.text =
                                  value.format(context).toString();
                            startTime = DateTime(start!.year,start!.month,start!.day,value!.hour,value.minute,0);
                            print(startTime);
                            print(timeController.text);
                          });
                        },
                        validate: (value) {
                          if (value != null) if (value.isEmpty) {
                            return 'Start time cannot be empty!';
                          }
                        },
                        keyboardType: TextInputType.datetime,
                        labelText: 'Start time',
                        prefix: Icons.watch_later_outlined,
                      ),
                      SizedBox(height: 20),
                      defaultFormField(
                          prefix: Icons.subject,
                          controller: subjectController,
                          validate: (value){

                          },
                          keyboardType: TextInputType.text,
                          labelText: 'Subject'
                      ),
                      SizedBox(height: 20,),
                      ProgressButton(
                        stateWidgets: {
                          ButtonState.idle: Text("Send request",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                          ButtonState.loading: Text("Loading",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                          ButtonState.fail: Text("Fail",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                          ButtonState.success: Text("Success",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
                        },
                        stateColors: {
                          ButtonState.idle: Colors.blueGrey,
                          ButtonState.loading: Colors.blue.shade300,
                          ButtonState.fail: Colors.red.shade300,
                          ButtonState.success: Colors.green.shade400,
                        },
                        onPressed: () {
                          if (_formKey?.currentState != null)
                            if (_formKey!.currentState!.validate()) {
                              AppointmentCubit.get(context).createAppointment(
                                  year: startTime!.year,
                                  month: startTime!.month,
                                  day: startTime!.day,
                                  hour: startTime!.hour,
                                  minute: startTime!.minute,
                                  subject: subjectController.text,
                                  agencyId: widget.agency,
                                  clientId: widget.client,
                                  accepted: false
                              );
                            }
                        },
                        state: buttonState,
                      ),
                    ],
                  ),
                ),
              )
          );
        },
        listener: (BuildContext context, Object? state) {
          if(state is CreateAppointmentLoadingState){
            setState(() {
              buttonState = ButtonState.loading;
            });
          }
          if(state is CreateAppointmentSuccessState){
            setState(() {
              buttonState = ButtonState.success;
            });
          }
          if(state is CreateAppointmentErrorState){
            setState(() {
              buttonState = ButtonState.fail;
            });
          }
        },
      ),
    );
  }
}