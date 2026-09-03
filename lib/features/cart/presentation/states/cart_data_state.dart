import 'package:international_cuisine/features/cart/data/models/cart_data_success_state.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sup_state.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';


class CartDataState extends MainAppSupState {
  final List<OrderModel> shoppingList;

  const CartDataState({
    required super.subState,
    required this.shoppingList
  });

  factory CartDataState.initial(){
    return CartDataState(
        shoppingList: [],
        subState: InitialState()
    );
  }

  int getTotalPrice() {
    int totalPrice = 0;
    shoppingList.forEach((e) => totalPrice += e.price * e.item);
    return totalPrice;
  }

  List<OrderModel> updateItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < shoppingList.length) {
      final orderModel = shoppingList[index];
      orderModel.item = newQuantity;
      shoppingList[index] = orderModel;
    }
    return shoppingList;
  }

  List<OrderModel> addOrder({
    required DataModel dataModel,
    required OrderModel orderModel
  }) {
    final updatedList = List<OrderModel>.from(shoppingList);
    final existingItemIndex = updatedList.indexWhere((item) =>
    item.order == orderModel.order);

    if (existingItemIndex != -1) {
      updatedList[existingItemIndex].item =
          updatedList[existingItemIndex].item + dataModel.getSelectedItem;
    } else {
      updatedList.add(orderModel);
    }
    return updatedList;
  }

  List<OrderModel> removeItem(int index) {
    final updatedList = List<OrderModel>.from(shoppingList);
    updatedList.removeAt(index);
    return updatedList;
  }

  CartDataState copyWith({
    MainAppSubState? subState,
    List<OrderModel>? shoppingList
  }) {
    return CartDataState(
      subState: subState ?? this.subState,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  @override
  CartDataSuccessState get dataModels =>
      throw CartDataSuccessState(shoppingList: shoppingList);

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CartDataSuccessState) onLoaded,
    required R Function(AppException) onError
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded.call(dataModels),
        onError: (failure) => onError.call(failure));
  }
}



