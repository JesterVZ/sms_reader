import 'package:dio/dio.dart';
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
    String url = locator.get<SettingsModel>().serverLink == null ? '' : locator.get<SettingsModel>().serverLink!;
    var formData = FormData.fromMap({
      'my_number': locator.get<SettingsModel>().myNumber,
      'sender_number': message.address,
      'card': message.address == '900' ? locator.get<SettingsModel>().sberNumber : message.address == 'tinkoff' ? locator.get<SettingsModel>().tinkoffNumber : ''
    });
    final responce = await _apiClient.post(url, data: formData);
    if(responce.statusCode == 200){
      return responce.data;
    }
    return '';
  }
}