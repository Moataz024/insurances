import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/meeting_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'calendar_states.dart';

class CalendarCubit extends Cubit<CalendarStates>{
  CalendarCubit() : super(CalendarInitialState());  

  static CalendarCubit get(context) => BlocProvider.of(context);

  
  MeetingModel meetingModel = new MeetingModel();
  List<Appointment> meetings = <Appointment>[];
  
  void getAppointments() async {
    emit(LoadingMeetingsState());
    await FirebaseFirestore.instance.collection('appointments').get()
        .then((value) {
       value.docs.forEach((element) {
         if(element.get('client')== FirebaseAuth.instance.currentUser!.uid && element.get('updated') == true){
           meetingModel = MeetingModel.fromJson(element.data());
           meetings.add(new Appointment(
               startTime: DateTime(meetingModel.year!,meetingModel.month!,meetingModel.day!,meetingModel.hour!,meetingModel.minute!,0),
               endTime: DateTime(meetingModel.year!,meetingModel.month!,meetingModel.day!,meetingModel.hour!+2,meetingModel.minute!,0),
               subject: meetingModel.subject!,
               color: Colors.blue)
           );
         }
         });
       emit(MeetingsSuccessState());
    }).catchError((error)=> emit(MeetingsErrorState(error.toString())));

  }
  



}