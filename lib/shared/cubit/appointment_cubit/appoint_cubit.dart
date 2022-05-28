import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/meeting_model.dart';
import 'appoint_states.dart';

class AppointmentCubit extends Cubit<AppointmentStates>{
  AppointmentCubit() : super(AppointmentInitialState());

  static AppointmentCubit get(context) => BlocProvider.of(context);



   void createAppointment({
    required year,
    required month,
    required day,
    required hour,
    required minute,
    required subject,
    required agencyId,
    required clientId,
    required accepted,
})  {
    emit(CreateAppointmentLoadingState());
    MeetingModel appointment = new MeetingModel(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      subject: subject,
      agencyId: agencyId,
      client: clientId,
      accepted: accepted,
    );
     FirebaseFirestore.instance.collection('appointments').doc().set(
      appointment.toMap()
    ).then((value) {
      emit(CreateAppointmentSuccessState());
    }).catchError((error) => emit(CreateAppointmentErrorState(error.toString())));
  }



}