import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/data/models/base/json_model.dart';


class SendOrderModel implements JsonModel{

  final String userName;
  final String userPhone;
  final String userLocation;
  final List<OrderModel> shoppingList;

  SendOrderModel({
    required this.userName,
    required this.userPhone,
    required this.userLocation,
    required this.shoppingList,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userPhone': userPhone,
      'userLocation': userLocation,
      'shoppingList': shoppingList,
    };
  }
}