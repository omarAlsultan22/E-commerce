import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/home/presentation/controllers/slide_animation_controller.dart';


void main() {
  group('initialize', () {
    testWidgets('creates AnimationController with 800ms duration',
            (tester) async {
          final slideController = SlideAnimationController();
          slideController.initialize(const TestVSync());

          expect(slideController.controller.duration,
              const Duration(milliseconds: 800));

          slideController.dispose();
        });

    testWidgets('leftAnimation starts at 300 and ends at 0', (tester) async {
      final slideController = SlideAnimationController();
      slideController.initialize(const TestVSync());

      expect(slideController.leftAnimation.value, 300.0);

      // ← في البداية (controller.value = 0) → 300
      slideController.dispose();
    });

    testWidgets('rightAnimation starts at -300 and ends at 0', (tester) async {
      final slideController = SlideAnimationController();
      slideController.initialize(const TestVSync());

      expect(slideController.rightAnimation.value, -300.0);

      slideController.dispose();
    });

    testWidgets('leftAnimation reaches 0 after forward completes',
            (tester) async {
          final slideController = SlideAnimationController();
          slideController.initialize(const TestVSync());

          slideController.forward();
          await tester.pumpAndSettle();

          expect(slideController.leftAnimation.value, closeTo(0.0, 0.01));

          slideController.dispose();
        });

    testWidgets('rightAnimation reaches 0 after forward completes',
            (tester) async {
          final slideController = SlideAnimationController();
          slideController.initialize(const TestVSync());

          slideController.forward();
          await tester.pumpAndSettle();

          expect(slideController.rightAnimation.value, closeTo(0.0, 0.01));

          slideController.dispose();
        });

    testWidgets('forward animates over 800ms', (tester) async {
      final slideController = SlideAnimationController();
      slideController.initialize(const TestVSync());

      slideController.forward();

      // بعد 400ms (نصف) — القيمة بين 300 و 0
      await tester.pump(const Duration(milliseconds: 400));
      final midValue = slideController.leftAnimation.value;
      expect(midValue, lessThan(300.0));
      expect(midValue, greaterThan(0.0));

      // بعد 400ms إضافية — 0
      await tester.pump(const Duration(milliseconds: 400));
      expect(slideController.leftAnimation.value, closeTo(0.0, 0.01));

      slideController.dispose();
    });
  });

  group('dispose', () {
    testWidgets('disposes controller without error', (tester) async {
      final slideController = SlideAnimationController();
      slideController.initialize(const TestVSync());

      expect(() => slideController.dispose(), returnsNormally);
    });
  });
}