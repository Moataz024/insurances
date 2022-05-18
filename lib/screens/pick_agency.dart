import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  var setDefaultMake = true, setDefaultMakeModel = true;
  var agency;
  bool refreshed = true;
  final _formKey = GlobalKey<FormState>();
  var selectedValue = null;
  var agencyName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => InsurancesAgencyCubit(),
      child: BlocConsumer<InsurancesAgencyCubit,InsurancesAgencyStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state)=> Scaffold(
          appBar: AppBar(

          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('agencies')
                        .orderBy('name')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Safety check to ensure that snapshot contains data
                      // without this safety check, StreamBuilder dirty state warnings will be thrown
                      if (!(snapshot.hasData) || snapshot == null)
                        return Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: Container(
                              child: Text(
                                'No agencies found',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ),
                        );
                      // Set this value for default,
                      // setDefault will change if an item was selected
                      // First item from the List will be displayed
                      if (setDefaultMake) {
                        agency = snapshot.data?.docs[0].get('agencyId');
                        debugPrint('setDefault make: $agency');
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 110,
                              bottom: 20,
                            ),
                            child: Text(
                              'Choose your agency',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          divider(),
                          SizedBox(height: 100,),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.0),
                                  border: Border.all()),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: SingleChildScrollView(
                                  child: Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: agency,
                                      items: snapshot.data?.docs.map((value) {
                                        return DropdownMenuItem(
                                          value: value.get('agencyId'),
                                          child: Text('${value.get('name')}'),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(
                                              () {
                                                agency = value;
                                            // Selected value will be stored
                                            // Default dropdown value won't be displayed anymore
                                            setDefaultMake = false;
                                            // Set makeModel to true to display first car from list
                                            setDefaultMakeModel = true;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 80,),
                Center(
                  child: agency != null
                      ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('agencies')
                        .where('agencyId', isEqualTo: agency)
                        .orderBy("name").snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        debugPrint('snapshot status: ${snapshot.error}');
                        return Container(
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Text(
                                    'Your agency is : ',
                                  ),
                                ),
                                Text('$agencyName',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    backgroundColor:agencyName == null ? Colors.grey : Colors.blue,
                                    child: Icon(
                                      Icons.navigate_next,
                                    ),
                                    isExtended: true,
                                    onPressed: () {
                                    agency == null ? Navigator.push(context,MaterialPageRoute(builder: (context)=> EmployeeWithAgencyExistsRegisterScreen(agencyId: agency,)))
                                    :
                                        showToast(
                                            message: 'Please select your agency'
                                        );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (setDefaultMakeModel) {
                        agencyName = snapshot.data?.docs[0].get('name');
                        debugPrint('setDefault agency name: $agencyName');
                      }
                      return SingleChildScrollView(
                        child: DropdownButton(
                          isExpanded: false,
                          value: agencyName,
                          items: snapshot.data?.docs.map((value) {
                            return DropdownMenuItem(
                              value: value.get('name'),
                              child: Text(
                                '${value.get('name')}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                                  () {
                                // Selected value will be stored
                                agencyName = value;
                                // Default dropdown value won't be displayed anymore
                                setDefaultMakeModel = false;
                              },
                            );
                          },
                        ),
                      );
                    },
                  )
                      : Text('agency is null agency id : $agency agency name: $agencyName , please choose your agency.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}