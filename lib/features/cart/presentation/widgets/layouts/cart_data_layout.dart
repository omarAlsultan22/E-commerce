import 'package:international_cuisine/core/presentation/utils/helpers/image_helpers.dart';
import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../maps/presentation/screens/maps_screen.dart';
import '../../../../../core/data/data_sources/local/hive.dart';
import '../../../data/models/order_model.dart';
import '../../cubits/cart_data_cubit.dart';
import 'package:flutter/material.dart';


class CartDataLayout extends StatefulWidget {
  final List<OrderModel> _shoppingList;
  const CartDataLayout(this._shoppingList, {super.key});

  @override
  State<CartDataLayout> createState() => _CartDataLayoutState();
}

class _CartDataLayoutState extends State<CartDataLayout> with WidgetsBindingObserver{
  late CartDataCubit _cubit;

  static const _paddingAll = EdgeInsets.all(16);
  static const _amber =  AppColors.primaryAmber;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.paused){
      CartDataCubit.get(context).saveCartToHive();
      await HiveStore.closeBox();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    _cubit = CartDataCubit.get(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
          elevation: AppNumbers.zero,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'عربة التسوق',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: _paddingAll,
                itemCount: widget._shoppingList.length,
                separatorBuilder: (_, __) => AppSpacing.height_12,
                itemBuilder: (context, index) =>
                    CartItemCard(
                      item: widget._shoppingList[index],
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
            _buildOrderSummary(widget._shoppingList),
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
      padding: _paddingAll,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorders.borderRadius_12,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المجموع الكلي:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '$totalAmount ج',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {

    return Padding(
      padding: _paddingAll,
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FixedLocationPicker())),
          style: ElevatedButton.styleFrom(
              backgroundColor: _amber,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorders.borderRadius_8,
              )),
          child: const Text(
            'اطلب الآن',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}


class CartItemCard extends StatelessWidget {
  final OrderModel item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    const _oneHundredTwenty = 120.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorders.borderRadius_12,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            spreadRadius: 2.0,
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: item.image,
              width: _oneHundredTwenty,
              height: _oneHundredTwenty,
              memCacheHeight: ImageHelpers.calculateOptimalCacheHeight(
                context,
                targetHeight: _oneHundredTwenty,
                qualityFactor: 1.5
              ),
              memCacheWidth: ImageHelpers.calculateOptimalCacheWidth(
                  context,
                  targetWidth: _oneHundredTwenty
              ),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: AppPaddings.paddingAll_12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.order,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: onRemove,
                      ),
                    ],
                  ),
                  AppSpacing.height_8,
                  Text(
                    '${item.price} ج',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryAmber,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => onQuantityChanged(item.item - 1),
                      ),
                      Text(
                        item.item.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => onQuantityChanged(item.item + 1),
                      ),
                      const Spacer(),
                      Text(
                        '${item.price * item.item} ج',
                        style: const TextStyle(
                          fontSize: 16,
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

