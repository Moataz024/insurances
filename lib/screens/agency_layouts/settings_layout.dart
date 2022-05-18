import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/reset_password.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/agency_cubit/cubit.dart';
import 'package:insurances/shared/cubit/employee_cubit/states.dart';
import 'package:insurances/shared/cubit/register_cubit/states.dart';
import 'package:insurances/shared/cubit/screeens_cubits/settings_cubit.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../shared/cubit/employee_cubit/cubit.dart';
import '../../shared/cubit/register_cubit/cubit.dart';
import '../../shared/cubit/screeens_cubits/settings_states.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SettingsCubit(),
      child: BlocConsumer
        <SettingsCubit,SettingsStates>(
        builder: (BuildContext context, state) => SettingsList(
          sections: [
            SettingsSection(
              title: Text('Security'),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: Text('Reset password'),
                  value: Text('Reset passwoed with email'),
                  leading: Icon(Icons.change_circle_rounded),
                  onPressed: (BuildContext context) {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => ResetPasswordScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
        listener: (BuildContext context, Object? state) {  },
      ),
    );
  }
}
