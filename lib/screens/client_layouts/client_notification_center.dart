import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/meeting_model.dart';
import 'package:insurances/shared/cubit/screeens_cubits/cliNotifCubit.dart';
import 'package:insurances/shared/cubit/screeens_cubits/cliNotifState.dart';

class ClientNotifications extends StatefulWidget {
  const ClientNotifications({Key? key}) : super(key: key);

  @override
  _ClientNotificationsState createState() => _ClientNotificationsState();
}

class _ClientNotificationsState extends State<ClientNotifications> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CliNotifCubit()..getAppointments(),
      child: BlocConsumer<CliNotifCubit, CliNotifStates>(
        listener: (BuildContext context, state) {
          if (state is NotificationSuccessState) {
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
          body: ConditionalBuilder(
                builder: (BuildContext context) => ConditionalBuilder(
                  condition: CliNotifCubit.get(context).meetings.length != 0,
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
                    itemBuilder: (context, position) => buildNotification(
                        context,
                        CliNotifCubit.get(context).meetings[position]),
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                    itemCount: CliNotifCubit.get(context).meetings.length,
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
        ),
      ),
    );
  }

  buildNotification(BuildContext context, MeetingModel meeting) {
    return ExpansionTileCard(
      leading: CircleAvatar(
        child: Text('M'),
        backgroundColor: Colors.blueGrey,
      ),
      title: Text('${meeting.subject}'),
      subtitle: Text('Date : ${meeting.day}/${meeting.month}/${meeting.year} at ${meeting.hour}:${meeting.minute == 0 ? '00' : meeting.minute}'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                meeting.updated != null && meeting.updated != false ?
                meeting.accepted == true ? Center(
                  child: Text(
                    "Accepted",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 16,
                    color: Colors.green),
                  ),
                ):
                Center(
                  child: Text(
                    "Declined",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 16,
                        color: Colors.redAccent),
                  ),
                ):
                Center(
                  child: Text(
                    "Pending...",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
