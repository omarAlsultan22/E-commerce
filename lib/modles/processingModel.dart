class ProcessingModel {

  final String userName;
  final String userPhone;
  final String userLocation;
  final Map<String, dynamic> userOrder;

  ProcessingModel({
    required this.userName,
    required this.userPhone,
    required this.userLocation,
    required this.userOrder,
  });


  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userPhone': userPhone,
      'userLocation': userLocation,
      'userOrder': userOrder,
    };
  }
}