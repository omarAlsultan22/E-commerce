import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';


class ItemRating extends StatelessWidget {
  final double userRating;
  final Function(double) onRatingUpdate;

  const ItemRating({
    Key? key,
    required this.userRating,
    required this.onRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingUpdate((index + 1).toDouble()),
          child: Icon(
            index < userRating ? Icons.star : Icons.star_border,
            color: AppColors.primaryAmber,
            size: 20.0,
          ),
        );
      }),
    );
  }
}