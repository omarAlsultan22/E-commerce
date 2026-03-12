import 'package:flutter/material.dart';
import '../../utils/helpers/image_helpers.dart';
import 'package:international_cuisine/core/constants/app_assets.dart';


class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          AppAssets.originalLogo,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
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
          child: const SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}