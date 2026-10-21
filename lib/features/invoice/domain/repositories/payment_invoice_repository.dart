import '../../../../core/data/models/user_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/domain/repositories/base_user_repository.dart';


abstract class PaymentInvoiceRepository implements BaseUserInfoRepository {
  Future<void> sendOrdersToDatabase({
    required UserModel? userInfo,
    required List<OrderModel> shoppingList,
  });
}