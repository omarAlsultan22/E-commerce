import 'package:cloud_firestore/cloud_firestore.dart';


class DataModel {
  final String orderImage;
  final String orderName;
  List<String>? ordersNumber;
  int rating;
  int orderPrice;
  bool isActive;
  int selectItem;
  bool likeIcon;
  bool dislikeIcon;

  DataModel({
    required this.orderImage,
    required this.orderName,
    required this.orderPrice,
    required this.rating,
    this.isActive = false,
    this.ordersNumber,
    this.likeIcon = false,
    this.dislikeIcon = false,
    this.selectItem = 1,
  });

  factory DataModel.fromJson(Map<String, dynamic> json){
    return DataModel(
        orderImage: json['orderImage'] ?? '',
        orderName: json['orderName'] ?? '',
        orderPrice: json['orderPrice'] ?? '',
        rating: json['rating'] ?? 4,
        isActive: false,
        selectItem: 1,
        likeIcon: false,
        dislikeIcon: false
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'orderImage': orderImage,
      'orderName': orderName,
      'orderPrice': orderPrice,
      'rating': rating
    };
  }
}

class DataList {
  List<DataModel> data;

  DataList({required this.data});

  factory DataList.fromQuerySnapshot(QuerySnapshot snapshot){
    List<DataModel> data = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      DataModel dataModel = DataModel.fromJson(map);
      data.add(dataModel);
    }
    return DataList(data: data);
  }
}