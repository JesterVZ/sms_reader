import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/model/log.dart';
import 'package:sms_reader/model/settings_model.dart';
import 'package:telephony/telephony.dart';
import 'dart:convert';

class HttpClient {
  final Dio _apiClient = _getDio(baseUrl: null);
  static Dio _getDio({String? baseUrl}) {
    return Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: 30000,
      contentType: Headers.jsonContentType,
    ));
  }

  Future<Object>? sendToServer(SmsMessage message) async {
    Log log = locator<Log>();
    log.messages +=
        ("${DateTime.now()} message address: ${message.address} \n");
    log.messages += ("${DateTime.now()} message body: ${message.body} \n");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? serverLink = preferences.getString('serverLink');

    String url = serverLink ?? '';
    log.messages += ("${DateTime.now()} serverLink: $url \n");
    var formData = FormData.fromMap({
      'my_number': preferences.getString('myNumber') ?? '',
      'sender_number': message.address,
      'card': message.address == '900'
          ? preferences.getString('sber')
          : message.address == 'Tinkoff'
              ? preferences.getString('tinkoff')
              : 'other number',
      'text': message.body
    });
    var responce;
    for (int i = 0; i < preferences.getStringList('numbersList')!.length; i++) {
      if (message.address == preferences.getStringList('numbersList')![i]) {
        log.messages +=
            ("${DateTime.now()} number: ${preferences.getStringList('numbersList')![i]} \n");
        responce = await _apiClient.post(url, data: formData);
        break;
      }
    }
    log.messages += ("${DateTime.now()} responce: $responce \n");
    log.messages += ("${DateTime.now()} responce.body: ${responce.data} \n");
    if (responce != null && responce.statusCode == 200) {
      return log;
    } else {
      throw Exception(responce);
    }
  }

  Future<Object> sendToServerBack(
      SmsMessage message, SharedPreferences preferences) async {
    String? serverLink = preferences.getString('serverLink');
    String url = serverLink ?? '';
    var formData = FormData.fromMap({
      'my_number': preferences.getString('myNumber') ?? '',
      'sender_number': message.address,
      'card': message.address == '900'
          ? preferences.getString('sber')
          : message.address == 'Tinkoff'
              ? preferences.getString('tinkoff')
              : 'other number',
      'text': message.body
    });
    var responce;
    for (int i = 0; i < preferences.getStringList('numbersList')!.length; i++) {
      if (message.address == preferences.getStringList('numbersList')![i]) {
        responce = await _apiClient.post(url, data: formData);
        break;
      }
    }
    if (responce != null && responce.statusCode == 200) {
      return responce.data;
    } else {
      throw Exception(responce);
    }
  }
}
