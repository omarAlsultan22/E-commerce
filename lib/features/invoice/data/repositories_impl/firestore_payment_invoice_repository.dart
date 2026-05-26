import '../modles/send_order_model.dart';
import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import '../../domain/repositories/payment_invoice_repository.dart';
import '../../presentation/utils/helpers/user_info_converter.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';


class FirestorePaymentInvoiceRepository implements PaymentInvoiceRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;

  FirestorePaymentInvoiceRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository
  })
      : _repository = repository,
        _cacheHelper = cacheHelper;

  static const uId = AppKeys.uId;

  @override
  Future<UserModel> getInfo() async {
    try {
      final userId = await _cacheHelper.getStringValue(key: uId);
      final location = await _cacheHelper.getStringValue(key: AppKeys.location);
      final doc = await _repository
          .getDocument(collectionPath: AppKeys.userInfo, docId: userId);


      if (!doc.exists) {
        throw Exception('User document does not exist');
      }

      return UserInfoConverter
          .fromDocumentSnapshot(doc, location!)
          .userModel;;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendOrdersToDatabase({
    required UserModel? userInfo,
    required List<OrderModel> shoppingList
  }) async {
    try {
      if (userInfo == null) {
        throw Exception('User model is null');
      }

      final userId = await _cacheHelper.getStringValue(key: uId);

      SendOrderModel data = SendOrderModel(
          userName: ('${userInfo.firstName} ${userInfo.lastName}'),
          userPhone: userInfo.userPhone,
          userLocation: userInfo.userLocation!,
          shoppingList: shoppingList
      );

      await _repository.setData(
          collectionPath: 'processingOrders',
          docId: userId,
          data: data.toJson());
    } catch (e) {
      rethrow;
    }
  }
}