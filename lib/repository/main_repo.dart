import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/http.dart';
import 'package:telephony/telephony.dart';

class MainRepo{
  Future<dynamic> sendToServer(SmsMessage message) async{
    var result = await locator.get<HttpClient>().sendToServer(message);
    return result;
  }
}