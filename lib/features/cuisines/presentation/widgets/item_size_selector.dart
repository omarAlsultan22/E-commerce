import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';


class ItemSizeSelector extends StatelessWidget {
  final Animation<Color?> colorAnimation;
  final Animation<double> scaleAnimation;
  final PageController sizeController;
  final List<String> mealSizes;
  final List<Color> mealColors;
  final int currentSizeIndex;

  const ItemSizeSelector({
    Key? key,
    required this.colorAnimation,
    required this.scaleAnimation,
    required this.sizeController,
    required this.mealSizes,
    required this.mealColors,
    required this.currentSizeIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: colorAnimation.value,
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.3),
                  blurRadius: 5.0,
                  offset: const Offset(0, 2.0),
                ),
              ],
            ),
            child: SizedBox(
              width: 60.0,
              height: 24.0,
              child: PageView.builder(
                controller: sizeController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mealSizes.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Text(
                      mealSizes[index],
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}