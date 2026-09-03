import '../../../cart/data/models/order_model.dart';
import '../../../../core/data/models/user_model.dart';
import 'package:international_cuisine/core/presentation/states/base/main_loaded_state.dart';


class PaymentInvoiceSuccessState extends LoadedState {
  final UserModel userModel;
  final List<OrderModel> shoppingList;

  const PaymentInvoiceSuccessState({
    required this.userModel,
    required this.shoppingList,
  });
}