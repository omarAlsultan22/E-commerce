import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/shared/utils/image_helpers.dart';


void main() {
  group('calculateOptimalCacheHeight', () {
    testWidgets('calculates height with pixelRatio 1.0', (tester) async {
      late int result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 1.0),
          child: Builder(
            builder: (context) {
              result = ImageHelpers.calculateOptimalCacheHeight(
                context,
                targetHeight: 100,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 100);
    });

    testWidgets('calculates height with pixelRatio 2.0', (tester) async {
      late int result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 2.0),
          child: Builder(
            builder: (context) {
              result = ImageHelpers.calculateOptimalCacheHeight(
                context,
                targetHeight: 100,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 200);
    });

    testWidgets('applies qualityFactor', (tester) async {
      late int result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 1.0),
          child: Builder(
            builder: (context) {
              result = ImageHelpers.calculateOptimalCacheHeight(
                context,
                targetHeight: 100,
                qualityFactor: 0.5,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 50);
    });

    testWidgets('rounds decimal result', (tester) async {
      late int result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 1.5),
          child: Builder(
            builder: (context) {
              result = ImageHelpers.calculateOptimalCacheHeight(
                context,
                targetHeight: 101,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 152); // 101 * 1.5 = 151.5 → 152
    });
  });

  group('calculateOptimalCacheWidth', () {
    testWidgets('calculates width with pixelRatio 1.0', (tester) async {
      late int result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 1.0),
          child: Builder(
            builder: (context) {
              result = ImageHelpers.calculateOptimalCacheWidth(
                context,
                targetWidth: 100,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 100);
    });

    testWidgets('calculates width with pixelRatio 3.0', (tester) async {
      late int result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 3.0),
          child: Builder(
            builder: (context) {
              result = ImageHelpers.calculateOptimalCacheWidth(
                context,
                targetWidth: 100,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, 300);
    });
  });
}