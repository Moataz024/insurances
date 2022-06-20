import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/screeens_cubits/cliNotifState.dart';
import '../../../model/meeting_model.dart';

class CliNotifCubit extends Cubit<CliNotifStates>{
  CliNotifCubit() : super(CliNotifInitialState());

  static CliNotifCubit get(context) => BlocProvider.of(context);

  MeetingModel meetingModel = new MeetingModel();
  List<MeetingModel> meetings = <MeetingModel>[];

  void getAppointments() async {
    emit(LoadingNotificationState());
    await FirebaseFirestore.instance.collection('appointments').get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.get('client')== FirebaseAuth.instance.currentUser!.uid){
          meetingModel = MeetingModel.fromJson(element.data());
          meetings.add(meetingModel);
        }
      });
      emit(NotificationSuccessState());
    }).catchError((error)=> emit(NotificationErrorState(error.toString())));

  }

}