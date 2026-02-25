import '../../../../core/data/models/user_info_model.dart';
import '../repositories/payment_invoice_repository.dart';
import '../../../cart/data/models/order_model.dart';


class PaymentInvoiceUseCase {
  final PaymentInvoiceRepository _repository;

  PaymentInvoiceUseCase({
    required PaymentInvoiceRepository userInfoRepository,
  })
      :_repository = userInfoRepository;

  Future<UserInfoModel> getInfoExecute() async {
    try {
      return await _repository.getInfo();
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> sendDataExecute({
    required UserInfoModel userInfo,
    required List<OrderModel> shoppingList,
  }) async {
    try {
      await _repository.sendOrdersToDatabase(
          userInfo: userInfo, shoppingList: shoppingList);
    }
    catch (e) {
      rethrow;
    }
  }
}

