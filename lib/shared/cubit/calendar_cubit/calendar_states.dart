abstract class CalendarStates {}

class CalendarInitialState extends CalendarStates {}

class LoadingMeetingsState extends CalendarStates {}

class MeetingsSuccessState extends CalendarStates {}

class MeetingsErrorState extends CalendarStates {
  final String error;

  MeetingsErrorState(this.error);
}
