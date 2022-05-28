import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/calendar_cubit/calendar_cubit.dart';
import 'package:insurances/shared/cubit/calendar_cubit/calendar_states.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  @override
  Widget build(BuildContext context) {
    var calendarView = CalendarView.week;
    return BlocProvider(
      create: (BuildContext context) => CalendarCubit()..getAppointments(),
      child: BlocConsumer<CalendarCubit,CalendarStates>(
        listener: (BuildContext context, state) {
          if(state is MeetingsErrorState){
            print(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {

          return Scaffold(
            appBar: AppBar(
            ),
            body: ConditionalBuilder(
              fallback: (BuildContext context) => LinearProgressIndicator(),
              condition: state is! LoadingMeetingsState,
              builder: (BuildContext context) {
                return  SfCalendar(
                  view: calendarView,
                  dataSource: MeetingDataSource(context),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(context){
    appointments = CalendarCubit.get(context).meetings;
  }
}


