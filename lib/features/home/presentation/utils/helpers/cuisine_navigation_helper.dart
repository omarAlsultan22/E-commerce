import 'package:flutter/material.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push.dart';

// Screens
import '../../../../cuisines/presentation/screens/french_screen.dart';
import '../../../../cuisines/presentation/screens/syrian_screen.dart';
import '../../../../cuisines/presentation/screens/chinese_screen.dart';
import '../../../../cuisines/presentation/screens/italian_screen.dart';
import '../../../../cuisines/presentation/screens/mexican_screen.dart';
import '../../../../cuisines/presentation/screens/turkish_screen.dart';
import '../../../../cuisines/presentation/screens/egyptian_screen.dart';
import '../../../../cuisines/presentation/screens/japanese_screen.dart';


class CuisineNavigationHelper {
  static const Map<int, Widget> _cuisineScreens = {
    0: EgyptianScreen(),
    1: SyrianScreen(),
    2: TurkishScreen(),
    3: MexicanScreen(),
    4: ChineseScreen(),
    5: JapaneseScreen(),
    6: ItalianScreen(),
    7: FrenchScreen(),
  };

  static Widget getScreen(int index) {
    return _cuisineScreens[index] ?? const SizedBox();
  }

  static void navigateToCuisine(BuildContext context, int index) {
    final screen = getScreen(index);
    if (screen is SizedBox) return;

    BuildNavigatorPush.build(
      context: context,
      link: screen,
    );
  }

  static List<int> getLeftColumnIndices() => [0, 2, 4, 6];
  static List<int> getRightColumnIndices() => [1, 3, 5, 7];
}