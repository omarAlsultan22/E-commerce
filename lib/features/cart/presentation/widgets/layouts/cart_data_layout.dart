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
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'عربة التسوق',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: widget._shoppingList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {

    const fifty = 50.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: fifty,
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FixedLocationPicker())),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
    //numbers constants
    const tow = 2.0;
    const five = 5.0;
    const oneHundredTwenty = 120.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: tow,
            blurRadius: five,
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
              width: oneHundredTwenty,
              height: oneHundredTwenty,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                  const SizedBox(height: 8),
                  Text(
                    '${item.price} ج',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 12),
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

