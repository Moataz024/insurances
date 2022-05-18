import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/agency_cubit/cubit.dart';
import 'package:insurances/shared/cubit/agency_cubit/states.dart';

import '../../shared/cubit/employee_cubit/cubit.dart';
import '../../shared/cubit/employee_cubit/states.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer
      <InsurancesAgencyCubit,InsurancesAgencyStates>(
      builder: (BuildContext context, state) => Container(),
      listener: (BuildContext context, Object? state) {  },
    );
  }
}
