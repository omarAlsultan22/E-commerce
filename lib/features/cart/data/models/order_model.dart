import '../../../../core/data/models/base/json_model.dart';
import 'package:hive/hive.dart';
part 'order_model.g.dart';


@HiveType(typeId: 0)
class OrderModel implements JsonModel{
  @HiveField(0)
  final String order;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final int price;

  @HiveField(3)
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