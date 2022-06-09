import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NumberElement extends StatefulWidget {
  TextEditingController controller;
  String title;
  String hint;
  NumberElement({Key? key, required this.controller, required this.title, required this.hint}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NumberElement();
}

class _NumberElement extends State<NumberElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Container(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                    hintText: widget.hint,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
            ),
          ]),
    );
  }
}
