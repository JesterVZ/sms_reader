class SmsModel{
  String? myNumber;
  String? senderNumber;
  String? card;
  String? text;

  SmsModel({
    required this.myNumber,
    required this.senderNumber,
    this.card,
    required this.text
  });
}