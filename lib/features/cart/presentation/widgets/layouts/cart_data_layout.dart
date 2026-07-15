import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/core/presentation/utils/helpers/image_helpers.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import '../../../../location/presentation/screens/fixed_location_picker_screen.dart';
import 'package:international_cuisine/core/constants/app_text_styles.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/order_model.dart';
import '../../cubits/cart_data_cubit.dart';
import 'package:flutter/material.dart';


class CartDataLayout extends StatefulWidget {
  final List<OrderModel> shoppingList;
  const CartDataLayout({
    required this.shoppingList,
    super.key
  });
  @override
  State<CartDataLayout> createState() => _CartDataLayoutState();
}

class _CartDataLayoutState extends State<CartDataLayout>{
  late CartDataCubit _cubit;
  final _cacheHelper = CacheHelper();

  @override
  void initState() {
    _cubit = CartDataCubit.get(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: AppValues.none,
          backgroundColor: AppColors.white,
          leading: BackButtonWidget(onPressed: ()=> Navigator.pop(context)),
          title: const Text(
            'عربة التسوق',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: AppPaddings.all_medium,
                itemCount: widget.shoppingList.length,
                separatorBuilder: (_, __) => AppSpaces.verticalSpacing_12,
                itemBuilder: (context, index) =>
                    CartItemCard(
                      order: widget.shoppingList[index],
                      onRemove: () => _cubit.removeItem(index),
                      onQuantityChanged: (newQuantity) {
                        if (newQuantity > 0) {
                          _cubit.updateItemQuantity(index, newQuantity);
                        } else {
                          _cubit.removeItem(index);
                        }
                      },
                    ),
              ),
            ),
            _buildOrderSummary(widget.shoppingList),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(List<OrderModel> _shoppingList) {
    final totalAmount = _shoppingList
        .fold(0, (sum, item) => sum + (item.price * item.item));

    return Container(
      padding: AppPaddings.all_medium,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorders.borderRadius_12,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            spreadRadius: 2.0,
            blurRadius: 5.0,
            offset: const Offset(0.0, -2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المجموع الكلي:',
            style: AppTextStyles.textStyle18,
          ),
          Text(
            '$totalAmount ج',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryAmber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: AppPaddings.all_medium,
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  FixedLocationPicker(cacheHelper: _cacheHelper)
              )
              ),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAmber,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorders.borderRadius_8,
              )),
          child: Text(
            'اطلب الآن',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSize18,
            ),
          ),
        ),
      ),
    );
  }
}


class CartItemCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    required this.order,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  //spaces
  static const _spacing120 = 120.0;

  //sizes
  static const _iconSize = 20.0;
  static const _borderRadius = 20.0;
  static const _fontSize = AppSizes.fontSize16;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorders.borderRadius_12,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            spreadRadius: 2.0,
            blurRadius: 5.0,
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
                right: Radius.circular(_borderRadius)),
            child: CachedNetworkImage(
              imageUrl: order.image,
              width: _spacing120,
              height: _spacing120,
              memCacheHeight: ImageHelpers.calculateOptimalCacheHeight(
                  context,
                  targetHeight: _spacing120,
                  qualityFactor: AppValues.qualityFactor
              ),
              memCacheWidth: ImageHelpers.calculateOptimalCacheWidth(
                  context,
                  targetWidth: _spacing120
              ),
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) =>
                  Container(
                    color: AppColors.lightGrey200,
                    child: const Icon(Icons.fastfood, size: _spacing120),
                  ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: AppPaddings.all_Small,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.order,
                        style: const TextStyle(
                          fontSize: AppSizes.fontSize18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: _iconSize),
                        onPressed: onRemove,
                      ),
                    ],
                  ),
                  AppSpaces.verticalSpacing_8,
                  Text(
                    '${order.price} ج',
                    style: const TextStyle(
                      fontSize: _fontSize,
                      color: AppColors.primaryAmber,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => onQuantityChanged(order.item - 1),
                      ),
                      Text(
                        order.itemToString,
                        style: const TextStyle(fontSize: _fontSize),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => onQuantityChanged(order.item + 1),
                      ),
                      const Spacer(),
                      Text(
                        '${order.price * order.item} ج',
                        style: const TextStyle(
                          fontSize: _fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

