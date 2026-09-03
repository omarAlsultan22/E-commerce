import '../models/send_order_model.dart';
import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import '../../domain/repositories/payment_invoice_repository.dart';
import '../../presentation/utils/helpers/user_info_converter.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../core/data/data_sources/local/cache_helper.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/errors/exceptions/validation_exception.dart';


class FirestorePaymentInvoiceRepository implements PaymentInvoiceRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _repository;
  final SessionService _sessionService;

  FirestorePaymentInvoiceRepository({
    required CacheHelper cacheHelper,
    required FirestoreService repository,
    required SessionService sessionService,
  })
      : _repository = repository,
        _cacheHelper = cacheHelper,
        _sessionService = sessionService;

  @override
  Future<UserModel> getInfo() async {
    try {
      final location = await _cacheHelper.getString(key: AppKeys.location);
      final doc = await _repository
          .getDocument(collectionPath: AppKeys.userInfo, docId: 'Lcjp7FoCPAo0U3yqqRmm');


      if (!doc.exists) {
        throw Exception('User document does not exist');
      }

      return UserInfoConverter
          .fromDocumentSnapshot(doc, location)
          .userModel;
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
        throw ValidationException(message: 'User information is required to place an order');
      }

      SendOrderModel data = SendOrderModel(
          userName: ('${userInfo.firstName} ${userInfo.lastName}'),
          userPhone: userInfo.userPhone,
          userLocation: userInfo.userLocation,
          shoppingList: shoppingList
      );

      await _repository.setData(
          collectionPath: 'processingOrders',
          docId: _sessionService.currentUid,
          data: data.toJson());
    } catch (e) {
      rethrow;
    }
  }
}