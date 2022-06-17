abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavState extends AppStates {}

class CheckingState extends AppStates {}

class CheckedState extends AppStates {}


class AppErrorState extends AppStates {
  final String error;

  AppErrorState(this.error);
}
