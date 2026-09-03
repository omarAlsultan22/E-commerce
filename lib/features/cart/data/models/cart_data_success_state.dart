import 'order_model.dart';
import 'package:international_cuisine/core/presentation/states/base/main_loaded_state.dart';


class CartDataSuccessState extends LoadedState {
  final List<OrderModel> shoppingList;

  const CartDataSuccessState({
    required this.shoppingList
  });
}