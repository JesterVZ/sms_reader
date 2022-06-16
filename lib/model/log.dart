import 'package:shared_preferences/shared_preferences.dart';

class Log {
  String messages = "";

  static void setPrefs(String text, SharedPreferences preferences) async {
    String base = preferences.getString('background_logs')!;
    base += text;
    preferences.setString('background_logs', "$base \n");
  }

  static void clear(SharedPreferences preferences) {
    preferences.setString('background_logs', "");
  }
}
