import '../modles/send_order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/models/user_info_model.dart';
import '../../domain/repositories/payment_invoice_repository.dart';
import '../../presentation/utils/helpers/user_info_converter.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';


class FirestoreInfoRepository implements PaymentInvoiceRepository {
  final FirebaseFirestore _repository;

  FirestoreInfoRepository({required FirebaseFirestore repository})
      : _repository = repository;


  @override
  Future<UserInfoModel> getInfo() async {
    try {
      final uId = await CacheHelper.getStringValue(key: 'uId');
      final location = await CacheHelper.getStringValue(key: 'location');
      final doc = await _repository
          .collection('user')
          .doc(uId).collection('userModel').doc(uId)
          .get();

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
    required UserInfoModel? userInfo,
    required List<OrderModel> shoppingList
  }) async {
    try {

      if (userInfo == null) {
        throw Exception('User model is null');
      }

      final uId = await CacheHelper.getStringValue(key: 'uId');

      SendOrderModel data = SendOrderModel(
          userName: ('${userInfo.firstName} ${userInfo.lastName}'),
          userPhone: userInfo.userPhone,
          userLocation: userInfo.userLocation!,
          shoppingList: shoppingList
      );

      await _repository.collection('processingOrders').doc(uId).set(
          data.toJson());
    } catch (e) {
      rethrow;
    }
  }
}