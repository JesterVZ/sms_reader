import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          child: Text("Настройки"),
        ),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
