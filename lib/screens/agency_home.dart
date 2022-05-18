
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/screens/chat_screen.dart';
import 'package:insurances/screens/login_screen.dart';
import 'package:insurances/shared/componenets/constants.dart';

import '../shared/cubit/app_cubit/cubit.dart';
import '../shared/cubit/app_cubit/states.dart';

class AgencyHomeScreen extends StatefulWidget {
  var index;
  AgencyHomeScreen({Key? key,this.index}) : super(key: key);

  @override
  _AgencyHomeScreenState createState() => _AgencyHomeScreenState();
}

class _AgencyHomeScreenState extends State<AgencyHomeScreen> {

  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state)
        {
          var cubit = AppCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Center(child: widget.index == null ? Text('${cubit.titles[cubit.currentIndex]}') : Text('${cubit.titles[widget.index]}')),
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
                IconButton(
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen()));
                    },
                    icon: Icon(Icons.message)
                ),

              ],
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (BuildContext context) => widget.index == null ? cubit.screens[cubit.currentIndex] : cubit.screens[widget.index],
              fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: lightTheme ? Colors.white : Colors.grey,
              index: widget.index == null ? cubit.currentIndex : widget.index,
              onTap: (index){
                setState(() {
                  widget.index = index;
                });
                cubit.changeIndex(index);
              },
              color: lightTheme ? Colors.blueAccent : Colors.blueGrey,
              items: <Widget>[
                Icon(Icons.home, size: 30,color: Colors.white,semanticLabel: 'Home'),
                Icon(Icons.groups, size: 30, color: Colors.white,semanticLabel: 'Team',),
                Icon(Icons.account_box, size: 30, color: Colors.white,semanticLabel: 'My account',),
                Icon(Icons.settings, size: 30 , color: Colors.white,semanticLabel: 'Settings',),
              ],

            ),
          );
        }
      ),
    );
  }
}
