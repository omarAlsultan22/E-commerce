import 'item_rating.dart';
import 'item_size_selector.dart';
import 'package:flutter/material.dart';
import '../../data/models/data_model.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/presentation/utils/helpers/image_helpers.dart';


class ItemImageSection extends StatefulWidget {
  final DataModel dataModel;
  final int currentSizeIndex;
  final PageController sizeController;
  final Animation<Color?> colorAnimation;
  final Animation<double> scaleAnimation;
  final List<String> mealSizes;
  final List<Color> mealColors;
  final VoidCallback onSizeChanged;
  final double userRating;
  final Function(double) onRatingUpdate;

  const ItemImageSection({
    Key? key,
    required this.dataModel,
    required this.currentSizeIndex,
    required this.sizeController,
    required this.colorAnimation,
    required this.scaleAnimation,
    required this.mealSizes,
    required this.mealColors,
    required this.onSizeChanged,
    required this.userRating,
    required this.onRatingUpdate,
  }) : super(key: key);

  @override
  State<ItemImageSection> createState() => _ItemImageSectionState();
}

class _ItemImageSectionState extends State<ItemImageSection> {
  // ✅ فقط الثوابت المستخدمة أكثر من مرة أو ذات معنى
  static const _imageHeight = 200.0;
  static const _overlayTopPosition = 10.0;
  static const _errorIconSize = 50.0;

  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _preloadImage();
  }

  Future<void> _preloadImage() async {
    try {
      await precacheImage(NetworkImage(widget.dataModel.orderImage!), context);
      if (mounted) {
        setState(() => _isImageLoaded = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImageLoaded = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isImageLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildImage(),
        _buildSizeSelectorOverlay(),
        _buildBottomOverlay(),
      ],
    );
  }

  Widget _buildImage() {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onSizeChanged,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
        child: Image.network(
          widget.dataModel.orderImage!,
          height: _imageHeight,
          width: double.infinity,
          cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
            context,
            targetHeight: _imageHeight,
            qualityFactor: AppValues.qualityFactor,
          ),
          cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
            context,
            targetWidth: screenSize.width,
          ),
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              Container(
                height: _imageHeight,
                color: AppColors.lightGrey300,
                child: const Icon(Icons.error, size: _errorIconSize),
              ),
        ),
      ),
    );
  }

  Widget _buildSizeSelectorOverlay() {
    return Positioned(
      top: _overlayTopPosition,
      right: _overlayTopPosition,
      child: ItemSizeSelector(
        colorAnimation: widget.colorAnimation,
        scaleAnimation: widget.scaleAnimation,
        sizeController: widget.sizeController,
        mealSizes: widget.mealSizes,
        mealColors: widget.mealColors,
        currentSizeIndex: widget.currentSizeIndex,
      ),
    );
  }

  Widget _buildBottomOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      child: Column(
        children: [
          _buildMealName(),
          const SizedBox(height: 4.0),
          ItemRating(
            userRating: widget.userRating,
            onRatingUpdate: widget.onRatingUpdate,
          ),
        ],
      ),
    );
  }

  Widget _buildMealName() {
    return Text(
      widget.dataModel.orderName!,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}