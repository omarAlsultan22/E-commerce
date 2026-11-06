import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/features/home/presentation/helpers/image_preloader.dart';


void main() {
  group('preloadImages', () {
    testWidgets('calls onComplete when homeData is empty', (tester) async {
      late bool onCompleteCalled;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              onCompleteCalled = false;
              ImagePreloader().preloadImages(
                context: context,
                onComplete: () => onCompleteCalled = true,
                homeData: [],
              );
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(onCompleteCalled, true);
    });

    testWidgets('calls onComplete even when images fail to load',
            (tester) async {
          late bool onCompleteCalled;

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  onCompleteCalled = false;
                  ImagePreloader().preloadImages(
                    context: context,
                    onComplete: () => onCompleteCalled = true,
                    homeData: [
                      HomeDataModel(image: 'invalid-url', title: 'A'),
                    ],
                  );
                  return const SizedBox();
                },
              ),
            ),
          );

          await tester.pumpAndSettle();

          // whenComplete → onComplete يُستدعى (حتى لو فشلت الصورة)
          expect(onCompleteCalled, true);
        });
  });
}