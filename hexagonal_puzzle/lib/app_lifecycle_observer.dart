import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  const AppLifecycleObserver({required this.child, super.key});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {

  final ValueNotifier<AppLifecycleState> lifecycleListenable =
  ValueNotifier(AppLifecycleState.inactive);

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<ValueNotifier<AppLifecycleState>>.value(
      value: lifecycleListenable,
      child: widget.child,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lifecycleListenable.value = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
}
