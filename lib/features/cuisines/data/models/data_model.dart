class DataModel {
  final String? orderImage;
  final String? orderName;
  List<String>? ordersNumber;
  int? rating;
  int? orderPrice;
  bool isActive;
  int selectedItem;

  DataModel({
    this.orderImage,
    this.orderName,
    this.orderPrice,
    this.rating,
    this.isActive = false,
    this.ordersNumber,
    this.selectedItem = 1,
  });

  int get getSelectedItem => selectedItem;

  factory DataModel.fromFirestore(Map<String, dynamic> json){
    return DataModel(
      orderImage: json['orderImage'] ?? '',
      orderName: json['orderName'] ?? '',
      orderPrice: json['orderPrice'] ?? '',
      rating: json['rating'] ?? 4,
      isActive: false,
      selectedItem: 1,
    );
  }

  DataModel copyWith({
    String? orderImage,
    String? orderName,
    List<String>? ordersNumber,
    int? rating,
    int? orderPrice,
    bool? isActive,
    int? selectItem,
  }) {
    return DataModel(
        orderImage: orderImage ?? this.orderImage,
        orderName: orderName ?? this.orderName,
        ordersNumber: ordersNumber ?? this.ordersNumber,
        rating: rating ?? this.rating,
        orderPrice: orderPrice ?? this.orderPrice,
        isActive: isActive ?? this.isActive,
        selectedItem: selectItem ?? this.selectedItem
    );
  }
}

