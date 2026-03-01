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

  //texts
  static const quantity = 'الكمية';
  static const  userName = 'الاسم:';
  static const userAddress = 'العنوان:';
  static const phoneNumber = 'الهاتف:';
  static const deliveryTime = 'وقت التوصيل المتوقع: 45-30 دقيقة';
  static const paid = 'تم الدفع بنجاح!';
  static const notPaid = 'لم يتم الدفع!';

  //numbers
  static const eighty = 80.0;

  Widget _buildWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildAppBar(
            title: widget.isPaid ?  paid : notPaid
        ),
        backgroundColor: Colors.grey[100],
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
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      leading:
      IconButton(
          icon: const Icon(Icons.home_filled, color: Colors.black),
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
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildDeliveryItem(shoppingList[index]),
    );
  }

  Widget _buildDeliveryItem(OrderModel orderModel) {
    final totalPrice = orderModel.price * orderModel.item;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                orderModel.image,
                width: eighty,
                height: eighty,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(
                      color: Colors.grey[200],
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' $quantity${orderModel.item}',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
          const SizedBox(height: 16),
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
        const SizedBox(height: 8),
        _buildInfoRow(' $userName${userModel.firstName + userModel.lastName}'),
        _buildInfoRow(' $userAddress${userModel.userLocation!}'),
        _buildInfoRow(' $phoneNumber${userModel.userPhone}'),
        _buildInfoRow(deliveryTime),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
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


