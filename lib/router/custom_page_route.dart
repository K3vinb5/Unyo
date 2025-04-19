import 'package:flutter/material.dart';

PageRouteBuilder customPageRouter(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Add the fade animation here
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.fastOutSlowIn),
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.ease, reverseCurve: Curves.fastOutSlowIn),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}
