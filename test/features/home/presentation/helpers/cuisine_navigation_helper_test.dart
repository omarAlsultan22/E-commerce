import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/cuisines/presentation/screens/french_screen.dart';
import 'package:international_cuisine/features/cuisines/presentation/screens/syrian_screen.dart';
import 'package:international_cuisine/features/cuisines/presentation/screens/turkish_screen.dart';
import 'package:international_cuisine/features/cuisines/presentation/screens/japanese_screen.dart';
import 'package:international_cuisine/features/cuisines/presentation/screens/egyptian_screen.dart';
import 'package:international_cuisine/features/home/presentation/helpers/cuisine_navigation_helper.dart';


void main() {
  group('getScreen', () {
    test('returns EgyptianScreen for index 0', () {
      final result = CuisineNavigationHelper.getScreen(0);

      expect(result, isA<EgyptianScreen>());
    });

    test('returns SyrianScreen for index 1', () {
      final result = CuisineNavigationHelper.getScreen(1);

      expect(result, isA<SyrianScreen>());
    });

    test('returns TurkishScreen for index 2', () {
      expect(CuisineNavigationHelper.getScreen(2), isA<TurkishScreen>());
    });

    test('returns JapaneseScreen for index 5', () {
      expect(CuisineNavigationHelper.getScreen(5), isA<JapaneseScreen>());
    });

    test('returns FrenchScreen for index 7', () {
      expect(CuisineNavigationHelper.getScreen(7), isA<FrenchScreen>());
    });

    test('returns SizedBox for invalid index', () {
      final result = CuisineNavigationHelper.getScreen(99);

      expect(result, isA<SizedBox>());
    });

    test('returns SizedBox for negative index', () {
      final result = CuisineNavigationHelper.getScreen(-1);

      expect(result, isA<SizedBox>());
    });
  });

  group('getLeftColumnIndices', () {
    test('returns [0, 2, 4, 6]', () {
      expect(
        CuisineNavigationHelper.getLeftColumnIndices(),
        [0, 2, 4, 6],
      );
    });
  });

  group('getRightColumnIndices', () {
    test('returns [1, 3, 5, 7]', () {
      expect(
        CuisineNavigationHelper.getRightColumnIndices(),
        [1, 3, 5, 7],
      );
    });
  });
}