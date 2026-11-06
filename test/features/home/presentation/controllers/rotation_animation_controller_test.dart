import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/home/presentation/controllers/rotation_animation_controller.dart';


void main() {
  group('start', () {
    test('calls onAngleUpdate with increasing angles', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: true,
        );

        // 1 frame = 16ms
        async.elapse(const Duration(milliseconds: 16));
        expect(angles.length, 1);
        expect(angles.first, closeTo(0.75, 0.01));

        // 2 frames
        async.elapse(const Duration(milliseconds: 16));
        expect(angles.length, 2);

        controller.dispose();
      });
    });

    test('completes after 8 seconds (480 frames)', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: true,
        );

        // 8 seconds = 480 frames
        async.elapse(const Duration(seconds: 8));

        expect(controller.isComplete, true);
        expect(controller.currentAngle, 360.0);
        expect(angles.last, 360.0);

        controller.dispose();
      });
    });

    test('stops emitting after completion', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: true,
        );

        async.elapse(const Duration(seconds: 8));
        final countAtCompletion = angles.length;

        // Advance more time
        async.elapse(const Duration(seconds: 2));

        expect(angles.length, countAtCompletion);  // ← لا مزيد

        controller.dispose();
      });
    });

    test('cancels timer when mounted is false', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: false,
        );

        async.elapse(const Duration(seconds: 1));

        expect(angles, isEmpty);  // ← لا استدعاء
        expect(controller.isComplete, false);

        controller.dispose();
      });
    });

    test('anglePerFrame is 0.75 (360 / 480)', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: true,
        );

        async.elapse(const Duration(milliseconds: 16));

        // 360 / (8 * 60) = 0.75
        expect(angles.first, closeTo(0.75, 0.001));

        controller.dispose();
      });
    });

    test('currentAngle never exceeds fullAngle', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: true,
        );

        async.elapse(const Duration(seconds: 10));  // ← أكثر من 8

        expect(controller.currentAngle, 360.0);
        expect(angles.every((a) => a <= 360.0), true);

        controller.dispose();
      });
    });
  });

  group('dispose', () {
    test('cancels the timer', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();
        final angles = <double>[];

        controller.start(
          onAngleUpdate: angles.add,
          mounted: true,
        );

        async.elapse(const Duration(milliseconds: 32));
        final countBeforeDispose = angles.length;

        controller.dispose();
        async.elapse(const Duration(seconds: 1));

        expect(angles.length, countBeforeDispose);  // ← لا مزيد
      });
    });

    test('is safe to call when not started', () {
      fakeAsync((async) {
        final controller = RotationAnimationController();

        expect(() => controller.dispose(), returnsNormally);
      });
    });
  });

  group('initial state', () {
    test('currentAngle is 0 and isComplete is false', () {
      final controller = RotationAnimationController();

      expect(controller.currentAngle, 0.0);
      expect(controller.isComplete, false);
    });
  });
}