import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/bloc/main_bloc.dart';
import 'package:sms_reader/bloc/main_state.dart';
import 'package:sms_reader/elements/bloc/bloc_screen.dart';
import 'package:telephony/telephony.dart';

import '../main.dart';
import 'main_page.dart';

class SmsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SmsPage();
}

class _SmsPage extends State<SmsPage> {
  final telephony = Telephony.instance;
  String _message = "";
  bool isStarted = false;
  MainBloc mainBloc = locator.get<MainBloc>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    if (result != null && result) {
      _ListenSms();
    }
  }

  Future onMessage(SmsMessage message) async {
    setState(() {
      if (isStarted) {
        _message = message.body ?? "Error reading message body.";
        locator.get<MainBloc>().sendToServer(message);
      }
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  void _ListenSms() {
    telephony.listenIncomingSms(
        onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocScreen<MainBloc, MainState>(
      bloc: mainBloc,
      listener: (context, state) => _listener(context, state),
      builder: (context, state) {
        return    Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: isStarted ? Colors.red : Colors.green),
                onPressed: () async {
                  if (isStarted == false) {
                    setState(() {
                      isStarted = true;
                    });
                  } else {
                    setState(() {
                      isStarted = false;
                    });
                  }
                },
                child: Text(isStarted ? "Stop" : "Start"),
              ),
            ),
          ),
          Text("Входящее смс: $_message")
        ],
      ),
    );
      }
    );
  }
  _listener(BuildContext context, MainState state) {
    if(state.loading == true){
      return;
    }
    if(state.error != null){
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Ошибка!"),
          content: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(state.error.toString())
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context, 'Cancel');
                }, 
                child: const Text("Cancel")),
            ],
          )
        ),
        ));
    }
  }
}
