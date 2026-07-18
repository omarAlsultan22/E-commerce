import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/core/presentation/utils/helpers/image_helpers.dart';


class CuisineCardWidget extends StatelessWidget {
  final HomeDataModel cuisine;
  final int index;
  final double spacing;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  const CuisineCardWidget({
    super.key,
    required this.cuisine,
    required this.index,
    required this.spacing,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          width: spacing,
          height: spacing,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.3),
                blurRadius: 8.0,
                offset: const Offset(AppValues.none, 4.0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildCuisineImage(context),
                _buildCuisineOverlay(),
                _buildCuisineTitle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCuisineImage(BuildContext context) {
    return Image.network(
      cuisine.image,
      fit: BoxFit.cover,
      cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
        context,
        targetHeight: spacing,
        qualityFactor: 1.5,
      ),
      cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
        context,
        targetWidth: spacing,
      ),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF424242),
          child: const Icon(
            Icons.broken_image,
            color: AppColors.white,
            size: 50.0,
          ),
        );
      },
    );
  }

  Widget _buildCuisineOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.transparent,
            AppColors.transparent,
            AppColors.black.withOpacity(0.8),
          ],
          stops: const [AppValues.none, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildCuisineTitle() {
    return Positioned(
      left: AppValues.none,
      right: AppValues.none,
      bottom: 12.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          cuisine.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: AppColors.white,
            shadows: [
              Shadow(
                blurRadius: 6.0,
                color: AppColors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}