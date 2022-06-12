import 'package:sms_reader/model/log.dart';

class MainState{
  final bool? loading;
  final Object? error;
  final Log? logs;
  MainState({this.loading, this.error, this.logs});

  static initial() => MainState(
    loading: false,
    error: null,
  );
  MainState copyWith({
    bool? loading,
    Object? error,
    Log? logs
  }){
    return MainState(
      error: error,
      loading: loading ?? this.loading,
      logs: logs
    );
  }
}