import 'package:equatable/equatable.dart';
import 'package:telephony/telephony.dart';

class Event extends Equatable{
  const Event();

  @override
  List<Object?> get props => [];
}

class SendToServerEvent extends Event{
  SmsMessage message;
  SendToServerEvent(this.message);
}