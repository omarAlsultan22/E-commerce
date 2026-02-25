class HomeDataModel {
  final String image;
  final String title;

  HomeDataModel({
    required this.image,
    required this.title,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      image: json['imageData'],
      title: json['title'],
    );
  }
}
