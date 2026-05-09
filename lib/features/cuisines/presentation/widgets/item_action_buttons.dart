import 'package:flutter/material.dart';
import '../../data/models/data_model.dart';
import '../../utils/size_price_calculator.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_text_styles.dart';


class ItemActionButtons extends StatelessWidget {
  final DataModel dataModel;
  final int currentSizeIndex;
  final List<String> mealSizes;
  final VoidCallback onAddToCartAndShowSnackBar;
  final VoidCallback onAddToCartAndNavigate;

  const ItemActionButtons({
    Key? key,
    required this.dataModel,
    required this.currentSizeIndex,
    required this.mealSizes,
    required this.onAddToCartAndShowSnackBar,
    required this.onAddToCartAndNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildQuantityDropdown(),
          const SizedBox(width: 8.0),
          _buildAddToCartButton(),
          const SizedBox(width: 8.0),
          _buildBuyNowButton(),
        ],
      ),
    );
  }

  Widget _buildQuantityDropdown() {
    final items = List.generate(10, (index) => (index + 1).toString());

    return Container(
      width: 70.0,
      height: 38.0,
      decoration: BoxDecoration(
        borderRadius: AppBorders.borderRadius_12,
        color: AppColors.lightGrey200,
      ),
      child: DropdownButtonFormField<String>(
        menuMaxHeight: 200.0,
        borderRadius: AppBorders.borderRadius_12,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        ),
        value: dataModel.selectedItem.toString(),
        items: items.map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: AppTextStyles.textStyle16,
          ),
        )).toList(),
        onChanged: (item) {
          if (item != null) {
            dataModel.selectedItem = int.parse(item);
          }
        },
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      width: 70.0,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.borderRadius_12,
        ),
        color: AppColors.lightGrey300,
        onPressed: onAddToCartAndShowSnackBar,
        child: const Icon(
          Icons.add_shopping_cart,
          size: 24.0,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildBuyNowButton() {
    final totalPrice = SizePriceCalculator.calculatePrice(dataModel, currentSizeIndex) * dataModel.selectedItem;

    return Expanded(
      child: MaterialButton(
        height: 38.0,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.borderRadius_12,
        ),
        color: AppColors.primaryAmber,
        onPressed: onAddToCartAndNavigate,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag),
            Text(
              '$totalPrice ج',
              style: AppTextStyles.textStyle16,
            ),
          ],
        ),
      ),
    );
  }
}