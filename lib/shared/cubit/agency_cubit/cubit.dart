import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/agency_cubit/states.dart';
import '../../../model/agency_model.dart';

class InsurancesAgencyCubit extends Cubit<InsurancesAgencyStates>{
  InsurancesAgencyCubit() : super(InsurancesAgencyInitialState());

  static InsurancesAgencyCubit get(context) => BlocProvider.of(context);
  List<Map<String,AgencyModel>> agencyList = [];
  void getAllAgencies() {
    FirebaseFirestore.instance.collection('agencies').snapshots().listen((value) {
      for (var element in value.docs) {
        agencyList.add(
            {element.reference.id: AgencyModel.fromJson(element.data())});
      }

      print(agencyList.length);
      emit(InsurancesAgencyGetSuccessState());
    });
  }
  void initialize(){
    FirebaseFirestore.instance
        .collection('agency')
        .where('agencyId', isEqualTo: agency)
        .orderBy("name").snapshots();
  }
  var agencyName;
  var agency;

  List<AgencyModel>? agencies;
  Future<void> getAgencies() async {
    // FirebaseFirestore.instance.collection('employees')
    //     .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get()
    //     .then((value) {
    //   value.docs.forEach((element) {
    //     employeeModel = EmployeeModel.fromJson(element.data());
    //   });
    // });
    emit(InsurancesAgencyGetLoadingState());
    await FirebaseFirestore.instance.collection('agencies').get().then((value) {
        value.docs.forEach((element) {
          agencies?.add(AgencyModel.fromJson(element.data()));
          print(element.data()['agencyId']);
          print(agencies?.length);
          print(agencies?[0].name);
          emit(InsurancesAgencyGetSuccessState());
        });
      if (agencies?.length == 0){
        print(agencies?[0].name);
        print('empty');
      }
    }).catchError((error) {
      emit(InsurancesAgencyGetErrorState(error.toString()));
      print('THERE IS AN ERROR : '+error.toString());
    });

  }
}