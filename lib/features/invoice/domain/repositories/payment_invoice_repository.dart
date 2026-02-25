import '../../../../core/data/models/user_info_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/data/repositories_impl/base_user_repository.dart';


abstract class PaymentInvoiceRepository implements BaseUserRepository {

  Future<void> sendOrdersToDatabase({
    required UserInfoModel userInfo,
    required List<OrderModel> shoppingList,
  });
}