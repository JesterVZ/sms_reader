class SettingsModel{
  String? serverLink;
  String? myNumber;
  List<String>? senderNumbers = [];
  String? sberNumber;
  String? tinkoffNumber;
  SettingsModel({
    this.serverLink,
    this.myNumber,
    this.senderNumbers,
    this.sberNumber,
    this.tinkoffNumber
  });
}