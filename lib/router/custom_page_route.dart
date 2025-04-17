import 'package:flutter/material.dart';

PageRouteBuilder customPageRouter(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Add the fade animation here
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.ease),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
  );
}
