import '../../../../core/domain/data_sources/local/cache_helper.dart';
import '../../../../core/domain/data_sources/remote/firestore_service.dart';
import '../models/send_order_model.dart';
import '../../../../core/data/models/user_model.dart';
import '../../domain/repositories/payment_invoice_repository.dart';
import '../../presentation/utils/helpers/user_info_converter.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/errors/exceptions/validation_exception.dart';


class PaymentInvoiceRepositoryImpl implements PaymentInvoiceRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _dataSource;
  final SessionService _sessionService;

  PaymentInvoiceRepositoryImpl({
    required CacheHelper cacheHelper,
    required FirestoreService dataSource,
    required SessionService sessionService,
  })
      : _dataSource = dataSource,
        _cacheHelper = cacheHelper,
        _sessionService = sessionService;

  @override
  Future<UserModel> getInfo() async {
    final location = await _cacheHelper.getString(key: AppKeys.location);
    final doc = await _dataSource
        .getDocument(
        collectionPath: AppKeys.userInfo, docId: 'Lcjp7FoCPAo0U3yqqRmm');


    if (!doc.exists) {
      throw Exception('User document does not exist');
    }

    return UserInfoConverter
        .fromDocumentSnapshot(doc, location)
        .userModel;
  }

  @override
  Future<void> sendOrdersToDatabase({
    required UserModel? userInfo,
    required List<OrderModel> shoppingList
  }) async {
    if (userInfo == null) {
      throw ValidationException(
          message: 'User information is required to place an order');
    }

    SendOrderModel data = SendOrderModel(
        userName: ('${userInfo.firstName} ${userInfo.lastName}'),
        userPhone: userInfo.userPhone,
        userLocation: userInfo.userLocation,
        shoppingList: shoppingList
    );

    await _dataSource.setData(
        collectionPath: 'processingOrders',
        docId: _sessionService.currentUid,
        data: data.toJson());
  }
}