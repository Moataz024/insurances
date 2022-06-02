import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

        ],
      ),
    );
  }
}

Widget buildAppointmentRequest(context) {
  return ExpansionTileCard(
      leading: CircleAvatar(child: Text('A')),
      title: Text('Appointment request'),
      subtitle: Text('I expand!'),
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
            child: Text(
              "This is an appointment request",
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
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

              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.arrow_downward),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Open'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.arrow_upward),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Close'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.swap_vert),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Toggle'),
                ],
              ),
            ),
          ],
        ),
      ],
  );
}

Widget buildMemberRequest(context){
  return ExpansionTileCard(
    leading: CircleAvatar(child: Text('A')),
    title: Text('Appointment request'),
    subtitle: Text('I expand!'),
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
          child: Text(
            "This is an appointment request",
            style:
            Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
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

            },
            child: Column(
              children: <Widget>[
                Icon(Icons.arrow_downward),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                ),
                Text('Open'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.arrow_upward),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                ),
                Text('Close'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.swap_vert),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                ),
                Text('Toggle'),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
