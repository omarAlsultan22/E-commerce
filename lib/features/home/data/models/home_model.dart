class HomeDataModel {
  final String image;
  final String title;

  HomeDataModel({
    required this.image,
    required this.title,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      title: json['title'] ?? '',
      image: json['imageData'] ?? '',
    );
  }
}
