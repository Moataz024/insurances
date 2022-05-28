abstract class AppointmentStates {}

class AppointmentInitialState extends AppointmentStates {}

class CreateAppointmentLoadingState extends AppointmentStates {}

class CreateAppointmentSuccessState extends AppointmentStates {}

class CreateAppointmentErrorState extends AppointmentStates {
  final String error;

  CreateAppointmentErrorState(this.error);
}
