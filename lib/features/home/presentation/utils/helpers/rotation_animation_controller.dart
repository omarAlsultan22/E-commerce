import 'dart:async';
import 'package:flutter/material.dart';


class RotationAnimationController {
  static const double fullAngle = 360.0;
  static const double secondsToComplete = 8.0;

  Timer? _timer;
  double _currentAngle = 0.0;
  bool _isComplete = false;

  double get currentAngle => _currentAngle;
  bool get isComplete => _isComplete;

  void start({
    required Function(double) onAngleUpdate,
    required VoidCallback onComplete,
    required bool mounted,
  }) {
    final anglePerFrame = fullAngle / (secondsToComplete * 60);

    _timer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ 60),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        _currentAngle += anglePerFrame;
        if (_currentAngle >= fullAngle) {
          _currentAngle = fullAngle;
          timer.cancel();
          _isComplete = true;
          onComplete();
        }
        onAngleUpdate(_currentAngle);
      },
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}