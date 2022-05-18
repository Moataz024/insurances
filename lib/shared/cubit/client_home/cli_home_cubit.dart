import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/bill_model.dart';
import 'package:insurances/model/client_model.dart';
import 'package:insurances/screens/agency_layouts/settings_layout.dart';
import 'package:insurances/screens/client_layouts/cli_home_layout.dart';
import '../../../notification_api.dart';
import 'cli_home_states.dart';

class CliCubit extends Cubit<CliStates>{
  CliCubit() : super(CliInitialState());

  static CliCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int notId = 100;

  List<Widget> screens =
  [
    CliHomeLayout(),
    SettingsScreen(),
  ];

  List<String> titles =
  [
    'Home',
    'Settings',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(CliChangeBottomNavState());
  }

  ClientModel model = new ClientModel();

  Future<void> getClientByUid() async {
    await FirebaseFirestore.instance.collection('clients').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
        .then((value) {
          value.docs.forEach((element) {
            if(element.get('uid')== FirebaseAuth.instance.currentUser!.uid){
              model = ClientModel.fromJson(element.data());
            }
          });
    });
  }

  List<BillModel> bills = [];

  void getBills() async {
    await getClientByUid();
    FirebaseFirestore.instance.collection('bills').where('clientCIN',isEqualTo: model.cin.toString()).get()
        .then((value) {
          value.docs.forEach((element) {
            bills.add(BillModel.fromJson(element.data()));
            if(element.get('received')==false){
              notId++;
              NotificationService().showNotification(
                notId,
                'Facturation d\'assurance',
                'Facture de mantant : ${element.get('budget')} avec DLL : ${element.get('ddl')}',
                5,
              );
            }
            FirebaseFirestore.instance.collection('bills').doc(element.id)
            .update({'received' : true});
          });
          emit(GetBillsSuccessState());
    });
  }
}