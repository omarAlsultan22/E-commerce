class DataModel {
  final String? orderImage;
  final String? orderName;
  List<String>? ordersNumber;
  int? rating;
  int? orderPrice;
  bool isActive;
  int selectItem;
  bool likeIcon;
  bool dislikeIcon;

  DataModel({
    this.orderImage,
    this.orderName,
    this.orderPrice,
    this.rating,
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
}

