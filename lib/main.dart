import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/bloc/main_bloc.dart';
import 'package:sms_reader/http.dart';
import 'package:sms_reader/pages/main_page.dart';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) async {
  createIsolate(message);
}

void createIsolate(SmsMessage message) async {
  ReceivePort receivePort = ReceivePort();
  receivePort.asBroadcastStream();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Isolate newIsolate;
  newIsolate = await Isolate.spawn(
      sendToServerOnBack, [receivePort.sendPort, message, preferences]);
  receivePort.listen((message) {
    receivePort.close();
    newIsolate.kill();
  });
  
}

void sendToServerOnBack(List<Object> args) async {
  SendPort sendPort = args[0] as SendPort;
  SmsMessage message = args[1] as SmsMessage;
  SharedPreferences preferences = args[2] as SharedPreferences;
  HttpClient client = HttpClient();
  var result = await client.sendToServerBack(message, preferences);
  sendPort.send(result);
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
