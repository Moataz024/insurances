import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/screens/employee_register.dart';
import 'package:insurances/shared/componenets/components.dart';
import 'package:insurances/shared/cubit/agency_cubit/cubit.dart';
import 'package:insurances/shared/cubit/agency_cubit/states.dart';

import '../model/agency_model.dart';
import 'exists_emp_register.dart';

class FormValidationWithDropdown extends StatefulWidget {
  @override
  _FormValidationWithDropdownState createState() =>
      _FormValidationWithDropdownState();
}

class _FormValidationWithDropdownState
    extends State<FormValidationWithDropdown> {
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => InsurancesAgencyCubit()..getAllAgencies(),
        child: BlocConsumer<InsurancesAgencyCubit, InsurancesAgencyStates>(
          listener: (BuildContext context, state) {},
          builder: (BuildContext context, Object? state) => Scaffold(
            appBar: AppBar(),
            body: ConditionalBuilder(
              builder: (BuildContext context) => SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100.0),
                      child: AwesomeDropDown(
                        dropDownList: InsurancesAgencyCubit.get(context).agencyList,
                        selectedItem: selectedItem,
                        onDropDownItemClick: (selected){
                          setState(() {
                            selectedItem = selected;
                            print(selectedItem);
                            print(InsurancesAgencyCubit.get(context).agencyIdList[InsurancesAgencyCubit.get(context).agencyList.indexOf(selectedItem)-1]);
                          });
                        },

                      ),
                    ),

                    FloatingActionButton.extended(onPressed: (){
                      if(selectedItem == '' || selectedItem == 'Select your agency...'){
                        showToast(message: 'Please select your agency',gravity: ToastGravity.BOTTOM);
                      }else{
                        var agencyId = InsurancesAgencyCubit.get(context).agencyIdList[InsurancesAgencyCubit.get(context).agencyList.indexOf(selectedItem)-1];
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=> EmployeeWithAgencyExistsRegisterScreen(agencyId: agencyId,)));
                      }
                    }, label: Row(children: [
                      Text('Next'),
                      Icon(Icons.navigate_next),
                    ],))
                  ],
                ),
              ),
              fallback: (BuildContext context) => LinearProgressIndicator(),
              condition: state is! InsurancesAgencyGetLoadingState,
            ),
          ),
        ));
  }
}
