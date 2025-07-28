import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modles/data_model.dart';
import 'package:international_cuisine/modles/processingModel.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:international_cuisine/shared/local/shared_preferences.dart';
import '../../modles/order_model.dart';
import '../../modles/user_model.dart';

class CartCubit extends Cubit<CubitStates> {
  CartCubit() : super(InitialState());

  static CartCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  List<OrderModel> shoppingList = [];

  void addItem({
    required DataModel dataModel,
    required String orderSize,
    required BuildContext context
  }) {
    if (dataModel.selectItem <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الكمية يجب أن تكون أكبر من الصفر'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final delv = OrderModel(
      order: '${dataModel.orderName} ${orderSize}',
      image: dataModel.orderImage,
      price: dataModel.orderPrice,
      item: dataModel.selectItem,
    );

    final existingItemIndex = shoppingList.indexWhere((item) =>
    item.order == delv.order);

    if (existingItemIndex != -1) {
      shoppingList[existingItemIndex].item =
          shoppingList[existingItemIndex].item + dataModel.selectItem;
    } else {
      shoppingList.add(delv);
    }

    emit(SuccessState());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تمت الإضافة إلى السلة بنجاح'),
        backgroundColor: Colors.green[800],
      ),
    );
  }

  void removeItem(int index) {
    shoppingList.removeAt(index);
    emit(SuccessState());
  }

  void updateItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < shoppingList.length) {
      shoppingList[index].item = newQuantity;
      emit(SuccessState());
    }
  }

  void clearCart() {
    shoppingList.clear();
    emit(SuccessState());
  }

  int getTotalPrice() {
    int totalPrice = 0;
    shoppingList.forEach((e) => totalPrice += e.price * e.item);
    return totalPrice;
  }

  /*
  void addLocation(String location) {
    if (location.isNotEmpty) {
      userModel!.location = location;
      emit(CartUpdatedState());
    }
  }
   */

  Future<void> getUserInfo({required String uId}) async {
    emit(LoadingState());
    try {
      final location = await CacheHelper.getString(key: 'saved_address');
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(uId).collection('userModel').doc(uId)
          .get();

      if (!doc.exists) {
        throw Exception('User document does not exist');
      }

      userModel = UserInfo
          .fromDocumentSnapshot(doc, location!)
          .userModel;
      emit(SuccessState());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> sendOrdersToDatabase({
    required String uId
  }) async {
    try {
      final firebase = FirebaseFirestore.instance;
      Map<String, dynamic> order = {};

      shoppingList.forEach((e) {
        order[e.order] = e.item;
      });

      if (userModel == null) {
        emit(ErrorState('User model is null'));
        return;
      }


      ProcessingModel data = ProcessingModel(
          userName: ('${userModel!.firstName} ${userModel!.lastName}'),
          userPhone: userModel!.phone,
          userLocation: userModel!.location!,
          userOrder: order
      );

      await firebase.collection('processingOrders').doc(uId).set(data.toMap());
      emit(SuccessState());
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> saveCartToPrefs() async {
    try {
      final cartJson = jsonEncode(
          shoppingList.map((item) => item.toJson()).toList());

      await CacheHelper.setString(
          key: 'cartData',
          value: cartJson
      );

      await CacheHelper.setInt(
          key: 'cart_saved_time',
          value: DateTime.now().millisecondsSinceEpoch
      );
    } catch (e) {
      print('Error saving cart to prefs: $e');
      throw Exception('Failed to save cart data: $e');
    }
  }

  Future<void> loadCartFromPrefs() async {
    try {
      final savedTime = await CacheHelper.getInt(key: 'cart_saved_time') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      const expiryHours = 1;
      const expiryMilliseconds = expiryHours * 60 * 60 * 1000;

      if (savedTime == 0 || currentTime - savedTime > expiryMilliseconds) {
        print('Cart data expired or not found, removing...');
        await CacheHelper.remove(key: 'cartData');
        await CacheHelper.remove(key: 'cart_saved_time');
        shoppingList = [];
      } else {
        final cartJson = await CacheHelper.getString(key: 'cartData');
        shoppingList = cartJson != null
            ? (jsonDecode(cartJson) as List).map((e) => OrderModel.fromJson(e)).toList()
            : [];
      }
    } catch (e) {
      print('Error when loading cart from prefs: $e');
      throw Exception('Failed to load cart data: $e');
    }
  }
}

