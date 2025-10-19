import 'package:international_cuisine/shared/components/constant.dart';
import 'package:international_cuisine/modules/home/home_screen.dart';
import 'package:international_cuisine/shared/cubit/cubit.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:international_cuisine/modles/user_model.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../modles/order_model.dart';


class PaymentInvoice extends StatefulWidget {
  final String title;

  const PaymentInvoice({required this.title, super.key});

  @override
  State<PaymentInvoice> createState() => _PaymentInvoiceState();
}

class _PaymentInvoiceState extends State<PaymentInvoice> {

  bool lock = false;

  void _buildListener(CubitStates state) {
    if (state is ErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)));
    }
    if (state is SuccessState && !lock) {
      QuickAlert.show(
        context: context,
        title: 'تم ارسال طلبك بنجاح!',
        text: 'قم بأخذ لقطة شاشة للفتورة',
        type: QuickAlertType.success,
        showConfirmBtn: true,
        confirmBtnText: 'حسنا',
      );
      lock = true;
    }
  }


  Widget _buildWidget(BuildContext context, CubitStates state) {
    final cubit = CartCubit.get(context);
    final shoppingList = cubit.shoppingList;
    final userModel = cubit.userModel;

    if (userModel == null) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white,));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildAppBar(
            context: context,
            state: state,
            title: widget.title
        ),
        backgroundColor: Colors.grey[100],
        body: state is SuccessState ?
        _buildBody(shoppingList) : Center(
            child: Text('جاري إرسال طلبك...')),
        bottomNavigationBar: _buildBottomBar(
            context: context,
            shoppingList: shoppingList,
            userModel: userModel),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar({
    required BuildContext context,
    required CubitStates state,
    required String title
  }) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: state is SuccessState ?
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ) : SizedBox(),
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
          child: shoppingList.isEmpty ? _buildEmptyState() : _buildOrderList(
              shoppingList),
        ),
      ],
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'لا توجد طلبات للتوصيل',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك تصفح المطاعم وإضافة طلبات جديدة',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
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
                width: 80,
                height: 80,
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
                        'الكمية: ${orderModel.item}',
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
    required UserModel userModel
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


  Widget _buildDeliveryInfo(UserModel userModel) {
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
        _buildInfoRow('الاسم: ${userModel.firstName + userModel.lastName}'),
        _buildInfoRow(' العنوان: ${userModel.location!}'),
        _buildInfoRow('الهاتف: ${userModel.phone}'),
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
    CartCubit.get(context).getUserInfo(uId: UserDetails.uId);
    CartCubit.get(context).sendOrdersToDatabase(uId: UserDetails.uId);

    return BlocConsumer<CartCubit, CubitStates>(
        listener: (context, state) => _buildListener(state),
        builder: (context, state) => _buildWidget(context, state)
    );
  }
}


