import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/agency_model.dart';
import 'package:insurances/model/client_model.dart';
import 'package:insurances/model/employee_model.dart';
import 'cli_agency_states.dart';

class CliAgencyCubit extends Cubit<CliAgencyStates>{
  CliAgencyCubit() : super(CliAgencyInitialState());

  static CliAgencyCubit get(context) => BlocProvider.of(context);

  ClientModel cliModel = new ClientModel();
  AgencyModel agencyModel = new AgencyModel();
  EmployeeModel employeeModel = new EmployeeModel();
  void getAgency(){
    emit(LoadingAgencyState());
    FirebaseFirestore.instance.collection('clients').get()
      .then((value) {
       value.docs.forEach((element) {
         cliModel = ClientModel.fromJson(element.data());
         FirebaseFirestore.instance.collection('agencies').get()
          .then((value) {
            value.docs.forEach((element) {
              if(element.get('agencyId') == cliModel.agencyId){
                agencyModel = AgencyModel.fromJson(element.data());
              FirebaseFirestore.instance.collection('employees').get()
                .then((value) {
                 value.docs.forEach((element) {
                   if(element.get('uid')== agencyModel.responsibleId){
                     employeeModel = EmployeeModel.fromJson(element.data());
                   }
                 });
              });
              emit(GetAgencySuccessState());
              }
            });
         }).catchError((error)=> emit(GetAgencyErrorState(error.toString())));
       });
    }).catchError((error)=> emit(GetAgencyErrorState(error.toString())));
  }
}