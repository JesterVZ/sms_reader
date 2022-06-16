import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/bloc/main_bloc.dart';
import 'package:sms_reader/http.dart';
import 'package:sms_reader/model/log.dart';
import 'package:sms_reader/pages/main_page.dart';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) async {
  bool canVibrate = await Vibrate.canVibrate;
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Log.setPrefs("SmsMessage: ${message.body}", preferences);
  //preferences.setString('background_logs', "SmsMessage: $message \n");
  Dio dio = Dio(BaseOptions(
    baseUrl: '',
    connectTimeout: 30000,
    contentType: Headers.jsonContentType,
  ));
  String? serverLink = preferences.getString('serverLink');
  String url = serverLink ?? '';
  Log.setPrefs("serverLink: $serverLink ", preferences);
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
  Log.setPrefs("ready to request ", preferences);
  for (int i = 0; i < preferences.getStringList('numbersList')!.length; i++) {
    if (message.address == preferences.getStringList('numbersList')![i]) {
      responce = await dio.post(url, data: formData);
      Log.setPrefs("responce: ${responce.data}", preferences);
      if (canVibrate) Vibrate.vibrate;
      break;
    }
  }
}

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sms reader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage());
  }
}
