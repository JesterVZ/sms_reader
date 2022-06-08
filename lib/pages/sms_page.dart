import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    if (result != null && result) {
      try {
        telephony.listenIncomingSms(
            onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
      } catch (e) {
        _message = e.toString();
      }
    }
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  bool isStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
