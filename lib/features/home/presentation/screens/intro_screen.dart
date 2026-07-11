import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_assets.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import '../../../../core/presentation/utils/helpers/image_helpers.dart';
import 'package:international_cuisine/core/presentation/widgets/loading_widget.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
              targetHeight: screenSize.height,
              qualityFactor: AppValues.qualityFactor
          ),
          cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
              context,
              targetWidth: screenSize.width
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: const LoadingWidget(
                spacing: 25,
                strokeWidth: 2,
                color: AppColors.white
            )
        ),
      ],
    );
  }
}