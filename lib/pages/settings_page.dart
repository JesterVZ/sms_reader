import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/elements/number_elenemt.dart';
import 'package:sms_reader/model/phone_number.dart';
import 'package:sms_reader/model/settings_model.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  PhoneNumber? number;
  TextEditingController serverLinkController = TextEditingController();
  TextEditingController myNumberController = TextEditingController();
  TextEditingController tinkoffController = TextEditingController();
  TextEditingController sberController = TextEditingController();
  SharedPreferences? preferences;
  List<Widget> numbers = [];
  List<TextEditingController> additionalNumbers = [];
  List<String> numbersStr = [];


  @override
  void initState() {
    loadSettings();
    super.initState();
  }
  void updateSettings() {
    locator.get<SettingsModel>().myNumber = myNumberController.text;
    locator.get<SettingsModel>().serverLink = serverLinkController.text;
    locator.get<SettingsModel>().tinkoffNumber = tinkoffController.text;
    locator.get<SettingsModel>().sberNumber = sberController.text;
  }
  void loadSettings() async{
    preferences = await SharedPreferences.getInstance();
    String? link = preferences!.getString('serverLink');
    String? myNumber = preferences!.getString('myNumber');
    String? tinkoff = preferences!.getString('tinkoff');
    String? sber = preferences!.getString('sber');
    if(preferences!.getStringList('numbersList') != null){
      for(int i = 0; i < preferences!.getStringList('numbersList')!.length; i++){
        setState(() {
          TextEditingController textController = TextEditingController();
          textController.text = preferences!.getStringList('numbersList')![i];
          additionalNumbers.add(textController);
          numbers.add(NumberElement(controller: additionalNumbers.last, title: "Номер приема сообщений", hint: "+7(000)-000-00-00"));
        }); 
      }
    }
    serverLinkController.text = link ?? "";
    myNumberController.text = myNumber ?? "";
    tinkoffController.text = tinkoff ?? "";
    sberController.text = sber ?? "";
    //updateSettings();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          child: const Center(
              child: Text(
            "Настройки",
            style: TextStyle(fontSize: 25),
          )),
        ),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Адрес сервера'),
                          Container(
                            child: TextField(
                              controller: serverLinkController, //здесь вставляется адрес сервера
                              decoration: const InputDecoration(
                                  hintText: "http:/",
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                            ),
                          ),
                        ]),
                  ),
                  NumberElement(
                    controller: myNumberController,
                    hint: "+7(000)-000-00-00",
                    title: "Мой номер"
                  ),
                  NumberElement(
                    controller: tinkoffController,
                    hint: "0000-0000-0000-0000",
                    title: "Тинькофф"
                  ),
                  NumberElement(
                    controller: sberController,
                    hint: "0000-0000-0000-0000",
                    title: "Сбербанк"
                  ),
                  Container(
                    child: Column(
                      children: numbers,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          additionalNumbers.add(TextEditingController());
                          numbers.add(NumberElement(controller: additionalNumbers.last, title: "Номер приема сообщений", hint: "+7(000)-000-00-00"));
                        });
                      },
                      child: Text("Добавить номер"),
                    ),
                  ),
                  ElevatedButton(onPressed: () async{
                    updateSettings();
                    
                    await preferences?.setString('myNumber', myNumberController.text);
                    await preferences?.setString('serverLink', serverLinkController.text);
                    await preferences?.setString('tinkoff', tinkoffController.text);
                    await preferences?.setString('sber', sberController.text);
                    for(int i = 0; i < additionalNumbers.length; i++){
                      numbersStr.add(additionalNumbers[i].text);
                    }
                    await preferences?.setStringList('numbersList', numbersStr); 

                  }, child: Text("Сохранить"))
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    number = locator.get<PhoneNumber>();
  }
}
