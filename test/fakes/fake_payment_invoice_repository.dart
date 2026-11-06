import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/features/payment_invoice/domain/repositories/payment_invoice_repository.dart';


class FakePaymentInvoiceRepository implements PaymentInvoiceRepository {
  // ===== getInfo =====
  UserModel getInfoResult = UserModel(
    firstName: 'Ali',
    lastName: 'Ahmed',
    userPhone: '0123',
    userLocation: 'Cairo',
  );
  Object? getInfoError;
  int getInfoCallCount = 0;

  @override
  Future<UserModel> getInfo() async {
    getInfoCallCount++;
    if (getInfoError != null) throw getInfoError!;
    return getInfoResult;
  }

  // ===== sendOrdersToDatabase =====
  int sendOrdersCallCount = 0;
  UserModel? lastUserInfo;
  List<OrderModel>? lastShoppingList;
  Object? sendOrdersError;

  @override
  Future<void> sendOrdersToDatabase({
    required UserModel? userInfo,
    required List<OrderModel> shoppingList,
  }) async {
    sendOrdersCallCount++;
    lastUserInfo = userInfo;
    lastShoppingList = shoppingList;
    if (sendOrdersError != null) throw sendOrdersError!;
  }
}