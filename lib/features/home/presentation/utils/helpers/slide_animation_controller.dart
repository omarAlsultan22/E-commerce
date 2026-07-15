import 'package:flutter/material.dart';


class SlideAnimationController {
  static const double startPoint = 300.0;
  static const double endPoint = 0.0;

  late AnimationController _controller;
  late Animation<double> _leftColumnAnimation;
  late Animation<double> _rightColumnAnimation;

  AnimationController get controller => _controller;
  Animation<double> get leftAnimation => _leftColumnAnimation;
  Animation<double> get rightAnimation => _rightColumnAnimation;

  void initialize(TickerProvider vsync) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    _leftColumnAnimation = Tween<double>(begin: startPoint, end: endPoint).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _rightColumnAnimation = Tween<double>(begin: -startPoint, end: endPoint).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void forward() => _controller.forward();
  void dispose() => _controller.dispose();
}