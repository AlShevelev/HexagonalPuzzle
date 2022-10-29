import 'package:flutter/material.dart';

import 'view_model_base.dart';

class ViewModelProvider<T extends ViewModelBase> extends StatefulWidget {
  const ViewModelProvider({
    Key? key,
    required this.child,
    required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  State<ViewModelProvider<ViewModelBase>> createState() => _ViewModelProviderState<T>();

  static T of<T extends ViewModelBase>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ViewModelProvider<T>>()!.bloc;
  }
}

class _ViewModelProviderState<T> extends State<ViewModelProvider<ViewModelBase>> {
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
