class HomeModel {
  final String image;
  final String title;

  HomeModel({
    required this.image,
    required this.title,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      image: json['imageData'],
      title: json['title'],
    );
  }
}
