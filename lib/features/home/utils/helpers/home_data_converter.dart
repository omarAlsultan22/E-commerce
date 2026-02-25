import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/home_model.dart';


class HomeModelConverter {
  List<HomeDataModel> data;

  HomeModelConverter({required this.data});

  factory HomeModelConverter.fromQuerySnapshot(QuerySnapshot snapshot) {
    List<HomeDataModel> data = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      HomeDataModel homeModel = HomeDataModel.fromJson(docData);
      data.add(homeModel);
    }

    return HomeModelConverter(data: data);
  }
}