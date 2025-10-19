import 'json_model.dart';

class SendOrderModel implements JsonModel{

  final String userName;
  final String userPhone;
  final String userLocation;
  final Map<String, dynamic> userOrder;

  SendOrderModel({
    required this.userName,
    required this.userPhone,
    required this.userLocation,
    required this.userOrder,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userPhone': userPhone,
      'userLocation': userLocation,
      'userOrder': userOrder,
    };
  }
}