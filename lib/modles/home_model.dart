import 'package:cloud_firestore/cloud_firestore.dart';

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

class HomeList {
  List<HomeModel> data;

  HomeList({required this.data});

  factory HomeList.fromQuerySnapshot(QuerySnapshot snapshot) {
    List<HomeModel> data = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      HomeModel homeModel = HomeModel.fromJson(docData);
      data.add(homeModel);
    }

    return HomeList(data: data);
  }
}