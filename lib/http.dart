import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/model/settings_model.dart';
import 'package:telephony/telephony.dart';
import 'dart:convert';
class HttpClient{
  final Dio _apiClient = _getDio(baseUrl: null);
  static Dio _getDio({String? baseUrl}) {
    return Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: 30000,
      contentType: Headers.jsonContentType,
    ));
  }

  Future<Object>? sendToServer(SmsMessage message) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = locator.get<SettingsModel>().serverLink == null ? '' : locator.get<SettingsModel>().serverLink!;
    var formData = FormData.fromMap({
      'my_number': locator.get<SettingsModel>().myNumber,
      'sender_number': message.address,
      'card': message.address == '900' ? locator.get<SettingsModel>().sberNumber : message.address == 'tinkoff' ? locator.get<SettingsModel>().tinkoffNumber : '',
      'text': message.body
    });
    var responce;
    for(int i = 0; i < preferences.getStringList('numbersList')!.length; i++){
      if(message.address == preferences.getStringList('numbersList')![i]){
        responce = await _apiClient.post(url, data: formData);
        break;
      }
    }
    
    if(responce != null && responce.statusCode == 200){
      return responce.data;
    }
    return '';
  }
}