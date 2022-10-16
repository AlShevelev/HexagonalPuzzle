import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {
  SlideLeftRoute(Widget page)
      : super(
            pageBuilder: _createBuilder(page),
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: _createTransition());

  static RoutePageBuilder _createBuilder(Widget page) {
    return (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page;
  }

  static RouteTransitionsBuilder _createTransition() {
    return (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
  }
}
