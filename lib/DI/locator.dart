import 'package:get_it/get_it.dart';
import 'package:sms_reader/bloc/main_bloc.dart';
import 'package:sms_reader/http.dart';
import 'package:sms_reader/model/phone_number.dart';
import 'package:sms_reader/model/settings_model.dart';
import 'package:sms_reader/repository/main_repo.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<PhoneNumber>(() => PhoneNumber());
  locator.registerLazySingleton<HttpClient>(() => HttpClient());
  locator.registerLazySingleton<MainBloc>(() => MainBloc());
  locator.registerLazySingleton<MainRepo>(() => MainRepo());
  locator.registerLazySingleton<SettingsModel>(() => SettingsModel());
}
