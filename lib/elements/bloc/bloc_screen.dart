import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocScreen<B extends Bloc<dynamic, S>, S> extends StatelessWidget {
  final B? bloc;
  final BlocBuilderCondition<S>? buildWhen;
  final Widget Function(BuildContext context, S state) builder;

  final BlocListenerCondition<S>? listenWhen;
  final BlocWidgetListener<S> listener;

  BlocScreen({
    this.bloc,
    this.buildWhen,
    required this.builder,
    this.listenWhen,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: listenWhen,
      listener: listener,
      bloc: bloc,
      child: BlocBuilder<B, S>(
        bloc: bloc,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
