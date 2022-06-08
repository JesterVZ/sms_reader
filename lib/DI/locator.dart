import 'package:get_it/get_it.dart';
import 'package:sms_reader/model/phone_number.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<PhoneNumber>(() => PhoneNumber());
}
