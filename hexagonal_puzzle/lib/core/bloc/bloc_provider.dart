import 'package:flutter/material.dart';

import 'bloc_base.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  const BlocProvider({
    Key? key,
    required this.child,
    required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  State<BlocProvider<BlocBase>> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<BlocProvider<T>>()!.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
