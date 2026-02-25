import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';

import '../../../../core/errors/exceptions/app_exception.dart';
import 'package:international_cuisine/core/presentation/states/app_state.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';


class CartDataState{
  final AppState? appState;
  final List<OrderModel>? shoppingList;

  const CartDataState({
    this.appState,
    this.shoppingList = const [],
  });

  bool get isLoading => appState!.isLoading;

  AppException? get failure => appState!.failure!;

  List<OrderModel> get getShoppingList => shoppingList ?? [];

  int getTotalPrice() {
    int totalPrice = 0;
    getShoppingList.forEach((e) => totalPrice += e.price * e.item);
    return totalPrice;
  }

  List<OrderModel> updateItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < getShoppingList.length) {
      final orderModel = getShoppingList[index];
      orderModel.item = newQuantity;
      getShoppingList[index] = orderModel;
    }
    return getShoppingList;
  }

  List<OrderModel> addOrder({
    required DataModel dataModel,
    required OrderModel orderModel
  }) {
    final existingItemIndex = getShoppingList.indexWhere((item) =>
    item.order == orderModel.order);

    if (existingItemIndex != -1) {
      getShoppingList[existingItemIndex].item =
          getShoppingList[existingItemIndex].item + dataModel.getSelectedItem;
    } else {
      getShoppingList.add(orderModel);
    }
    return getShoppingList;
  }

  void removeItem(int index){
    getShoppingList.removeAt(index);
  }

  void clearCart(){
    getShoppingList.clear();
  }

  CartDataState copyWith({
    AppState? appState,
    List<OrderModel>? shoppingList,
  }) {
    return CartDataState(
      appState: appState ?? this.appState,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(List<OrderModel> data) onLoaded,
    required R Function(AppException error) onError,
  }) {
    if (failure != null) {
      return onError(failure!);
    }
    if (isLoading) {
      return onLoading();
    }
    if (getShoppingList.isNotEmpty) {
      return onLoaded(getShoppingList);
    }
    return onInitial();
  }
}



