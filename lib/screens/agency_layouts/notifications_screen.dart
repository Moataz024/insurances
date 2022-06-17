import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/notifications_cubit/cubit.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import '../../model/employee_model.dart';
import '../../model/meeting_model.dart';
import '../../shared/cubit/notifications_cubit/states.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Widget buildAppointmentRequest(context, MeetingModel meeting) {
    return ExpansionTileCard(
      leading: CircleAvatar(child: Text('AR')),
      title: Text('${meeting.subject}',style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
            '${meeting.day}/${meeting.month}/${meeting.day} at ${meeting.hour}:${meeting.minute == 0 ? '00' : meeting.minute}'),
      ),
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Text(
              "${meeting.clientName}",
              style:
              Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 20.0,
          buttonMinWidth: 30.0,
          children: <Widget>[
            TextButton(
              onPressed: () {
                NotifCubit.get(context).AcceptMeeting(model: meeting);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=> NotificationsScreen()));
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 30,
                    color: Colors.lightGreen,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    'Accept',
                    style: TextStyle(color: Colors.lightGreen),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                NotifCubit.get(context).DeclineMeeting(model: meeting);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=> NotificationsScreen()));
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: Colors.redAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    'Decline',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildMemberRequest(context,EmployeeModel model) {
    return ExpansionTileCard(
      leading: CircleAvatar(
        child: Text('MR'),
        backgroundColor: Colors.blueGrey,
      ),
      title: Text('${model.fullName}'),
      subtitle: Text('CIN : ${model.cin}'),
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                Text(
                  "Does he belong to your team?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 52.0,
          buttonMinWidth: 90.0,
          children: <Widget>[
            TextButton(
              onPressed: () {
                NotifCubit.get(context).AcceptMember(model: model);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=> NotificationsScreen()));
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 30,
                    color: Colors.lightGreen,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(color: Colors.lightGreen),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                NotifCubit.get(context).DeclineMember(model: model);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=> NotificationsScreen()));
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: Colors.redAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    'No',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NotifCubit()..getMemberRequests(),
      child: BlocConsumer<NotifCubit, NotifStates>(
        listener: (BuildContext context, state) {
          if (state is SuccessState) {
            Timer(Duration(seconds: 2), (){
              setState(() {
                loading = true;
              });
            });
          }
        },
        builder: (BuildContext context, Object? state) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
          ),
          body: TitleScrollNavigation(
            barStyle: TitleNavigationBarStyle(
              style: TextStyle(fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              spaceBetween: 40,
            ),
            titles: [
              "Appointment Requests",
              "Member Requests",
            ],
            pages: [
              ConditionalBuilder(
                builder: (BuildContext context) => ConditionalBuilder(
                  condition: NotifCubit.get(context).appointments.length != 0,
                  fallback: (BuildContext context) => Center(
                      child: Text(
                    'No appointment requests found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.grey),
                  )),
                  builder: (BuildContext context) => ListView.separated(
                    itemBuilder: (context, position) => buildAppointmentRequest(
                        context,
                        NotifCubit.get(context).appointments[position]),
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                    ),
                    itemCount: NotifCubit.get(context).appointments.length,
                  ),
                ),
                condition: loading,
                fallback: (BuildContext context) => Column(
                  children: [
                    LinearProgressIndicator(),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: Text(
                      'Loading data',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.grey),
                    )),
                  ],
                ),
              ),
              ConditionalBuilder(
                builder: (BuildContext context) => ConditionalBuilder(
                  condition: NotifCubit.get(context).memberRequests.length != 0,
                  fallback: (BuildContext context) => Center(
                      child: Text(
                        'No member requests found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.grey),
                      )),
                  builder: (BuildContext context) => ListView.separated(
                    itemBuilder: (context, position) => buildMemberRequest(
                        context,
                        NotifCubit.get(context).memberRequests[position]),
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                    itemCount: NotifCubit.get(context).memberRequests.length,
                  ),
                ),
                condition: loading,
                fallback: (BuildContext context) => Column(
                  children: [
                    LinearProgressIndicator(),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: Text(
                          'Loading data',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.grey),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


