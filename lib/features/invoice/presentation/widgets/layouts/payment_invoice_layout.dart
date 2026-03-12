import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import '../../../../../core/presentation/utils/helpers/image_helpers.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../home/presentation/screens/home_screen.dart';
import '../../../../../core/data/models/user_info_model.dart';
import '../../../../cart/data/models/order_model.dart';
import 'package:flutter/material.dart';


class PaymentInvoiceLayout extends StatefulWidget {
  final bool isPaid;
  final UserInfoModel userInfoModel;
  final List<OrderModel> shoppingList;

  const PaymentInvoiceLayout({
    required this.isPaid,
    required this.shoppingList,
    required this.userInfoModel,
    super.key
  });

  @override
  State<PaymentInvoiceLayout> createState() => _PaymentInvoiceLayoutState();
}

class _PaymentInvoiceLayoutState extends State<PaymentInvoiceLayout> {

  Widget _buildWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildAppBar(
            title: widget.isPaid ? 'تم الدفع بنجاح!' : 'لم يتم الدفع!'
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        body: _buildBody(widget.shoppingList),
        bottomNavigationBar: _buildBottomBar(
            context: context,
            shoppingList: widget.shoppingList,
            userModel: widget.userInfoModel),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    required String title
  }) {
    const zero = AppNumbers.zero;
    const black = AppColors.black;

    return AppBar(
      elevation: zero,
      scrolledUnderElevation: zero,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: black,
        ),
      ),
      centerTitle: true,
      leading:
      IconButton(
          icon: const Icon(Icons.home_filled, color: black),
          onPressed: () =>
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()))
      ),
    );
  }

  Widget _buildBody(List<OrderModel> shoppingList) {
    return Column(
      children: [
        Expanded(
          child: _buildOrderList(
              shoppingList),
        ),
      ],
    );
  }

  Widget _buildOrderList(List<OrderModel> shoppingList) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: shoppingList.length,
      separatorBuilder: (context, index) => AppSpacing.height_12,
      itemBuilder: (context, index) => _buildDeliveryItem(shoppingList[index]),
    );
  }

  Widget _buildDeliveryItem(OrderModel orderModel) {
    const _eighty = 80.0;
    final totalPrice = orderModel.price * orderModel.item;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.borderRadius_12,
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppPaddings.paddingAll_12,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppBorders.borderRadius_8,
              child: Image.network(
                orderModel.image,
                width: _eighty,
                height: _eighty,
                cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
                    context,
                    targetHeight: _eighty,
                    qualityFactor: 1.5
                ),
                cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
                    context,
                    targetWidth: _eighty
                ),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(
                      color: AppColors.lightGrey200,
                      child: const Icon(Icons.fastfood, size: 40),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderModel.order,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.height_8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الكمية ${orderModel.item}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '$totalPrice ج',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomBar({
    required BuildContext context,
    required List<OrderModel> shoppingList,
    required UserInfoModel userModel
  }) {
    if (shoppingList.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: AppPaddings.paddingAll_16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryInfo(userModel),
          AppSpacing.height_16,
          _buildTotalPrice(shoppingList),
        ],
      ),
    );
  }


  Widget _buildDeliveryInfo(UserInfoModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معلومات التوصيل',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.height_8,
        _buildInfoRow('الاسم: ${userModel.firstName + userModel.lastName}'),
        _buildInfoRow('العنوان: ${userModel.userLocation!}'),
        _buildInfoRow('الهاتف: ${userModel.userPhone}'),
        _buildInfoRow('وقت التوصيل المتوقع: 45-30 دقيقة'),
      ],
    );
  }

  Widget _buildInfoRow(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTotalPrice(List<OrderModel> shoppingList) {
    final totalAmount = shoppingList.fold(
        0, (sum, item) => sum + (item.price * item.item));

    return Container(
      padding: AppPaddings.paddingAll_12,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: AppBorders.borderRadius_8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'المجموع الكلي:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalAmount ج',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const Text(
                'التوصيل مجاني',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}


