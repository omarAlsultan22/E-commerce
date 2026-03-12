import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_assets.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../core/presentation/utils/helpers/image_helpers.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
          AppAssets.secondaryLogo,
          cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
              context,
              targetHeight: double.infinity,
              qualityFactor: 1.5
          ),
          cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
              context,
              targetWidth: double.infinity
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}