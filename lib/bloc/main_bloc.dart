import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_reader/DI/locator.dart';
import 'package:sms_reader/bloc/main_event.dart';
import 'package:sms_reader/bloc/main_state.dart';
import 'package:sms_reader/repository/main_repo.dart';
import 'package:telephony/telephony.dart';

class MainBloc extends Bloc<Event, MainState>{
  @override
  Stream<MainState> mapEventToState(Event event) async* {
    if(event is SendToServerEvent){
      yield* _handleSendToServer(event);
    }
  }

  MainBloc(): super(MainState.initial());

  sendToServer(SmsMessage message){
    add(SendToServerEvent(message));
  }

  Stream<MainState> _handleSendToServer(SendToServerEvent event) async*{
    yield state.copyWith(loading: true, error: null);
    try{
      final result = await locator.get<MainRepo>().sendToServer(event.message);
      yield state.copyWith(error: null, loading: false);
    }catch(e){
      yield state.copyWith(error: e.toString(), loading: false);
    }
  }
}