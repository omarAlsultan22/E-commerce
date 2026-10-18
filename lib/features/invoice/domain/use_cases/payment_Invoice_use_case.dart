import '../../../../core/data/models/user_model.dart';
import '../repositories/payment_invoice_repository.dart';
import '../../../cart/data/models/order_model.dart';


class PaymentInvoiceUseCase {
  final PaymentInvoiceRepository _repository;

  PaymentInvoiceUseCase({
    required PaymentInvoiceRepository userInfoRepository,
  })
      :_repository = userInfoRepository;

  Future<UserModel> getInfoExecute() async {
    return await _repository.getInfo();
  }

  Future<void> sendDataExecute({
    required UserModel? userInfo,
    required List<OrderModel> shoppingList,
  }) async {
    await _repository.sendOrdersToDatabase(
        userInfo: userInfo, shoppingList: shoppingList);
  }
}

