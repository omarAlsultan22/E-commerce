import 'package:international_cuisine/modles/json_model.dart';

class OrderModel implements JsonModel{
  final String order;
  final String image;
  final int price;
  int item;

  OrderModel({
    required this.order,
    required this.image,
    required this.price,
    this.item = 1,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json){
    return OrderModel(
      order: json['order'] ?? '',
      image: json['order'] ?? '',
      price: json['order'] ?? '',
      item: json['item'] ?? 1,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'image': image,
      'price': price,
      'item': item,
    };
  }
}