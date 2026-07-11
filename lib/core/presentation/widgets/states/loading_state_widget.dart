import 'package:flutter/material.dart';
import '../../utils/helpers/image_helpers.dart';
import 'package:international_cuisine/core/constants/app_assets.dart';


class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          AppAssets.originalLogo,
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
          cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
              context,
              targetHeight: _screenSize.height,
              qualityFactor: 1.5
          ),
          cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
              context,
              targetWidth: _screenSize.width
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