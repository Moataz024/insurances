import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/shared/cubit/screeens_cubits/settings_states.dart';

import '../../componenets/constants.dart';

class SettingsCubit extends Cubit<SettingsStates>{
  SettingsCubit() : super(SettingsInitialState());

  static SettingsCubit get(context) => BlocProvider.of(context);


  bool light = false;
  changeTheme(value){
    light = value;
    emit(ChangeThemeState());
  }


}