import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/componenets/constants.dart';
import 'package:insurances/shared/cubit/client_home/cli_home_cubit.dart';
import 'package:insurances/shared/cubit/client_home/cli_home_states.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../notification_api.dart';
import 'login_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }
  @override
  Widget build(BuildContext context) {
    int notId = 300;
    return BlocProvider(
      create: (BuildContext context) => CliCubit()..getBills(),
      child: BlocConsumer<CliCubit,CliStates>(
        listener: (BuildContext context, state) {
        },
        builder: (BuildContext context, Object? state) {
          var cubit = CliCubit.get(context);
          return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: lightTheme ? Colors.white : Colors.grey,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              color: lightTheme ? Colors.blueAccent : Colors.blueGrey,
              index: cubit.currentIndex,
              items: <Widget>[
                Icon(Icons.home, size: 30,
                    color: Colors.white,
                    semanticLabel: 'Home'),
                Icon(Icons.settings, size: 30,
                  color: Colors.white,
                  semanticLabel: 'Settings',),
              ],

            ),
            appBar: AppBar(
              title: Center(child:  Text('${cubit.titles[cubit.currentIndex]}')),
              backgroundColor: lightTheme ? Colors.blueAccent : Colors.blueGrey,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: (){
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> loginScreen()));
                      });
                    },
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.notifications)
                ),

              ],
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        }
      ),
    );
  }
}
