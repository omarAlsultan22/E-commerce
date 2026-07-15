class DataModel {
  int? rating;
  bool isActive;
  int selectedItem;
  final int? orderPrice;
  final String? orderName;
  final String? orderImage;
  final List<String>? ordersNumber;

  DataModel({
    this.rating,
    this.orderName,
    this.orderImage,
    this.orderPrice,
    this.ordersNumber,
    this.isActive = false,
    this.selectedItem = 1,
  });

  int get getSelectedItem => selectedItem;

  double get ratingToDouble => rating!.toDouble();

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

