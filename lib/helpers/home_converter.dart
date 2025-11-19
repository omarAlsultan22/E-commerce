import 'package:cloud_firestore/cloud_firestore.dart';
import '../modles/home_model.dart';


class HomeModelConverter {
  List<HomeModel> data;

  HomeModelConverter({required this.data});

  factory HomeModelConverter.fromQuerySnapshot(QuerySnapshot snapshot) {
    List<HomeModel> data = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      HomeModel homeModel = HomeModel.fromJson(docData);
      data.add(homeModel);
    }

    return HomeModelConverter(data: data);
  }
}