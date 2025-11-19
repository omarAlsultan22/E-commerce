import '../modles/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DataModelConverter {
  List<DataModel> data;

  DataModelConverter({required this.data});

  factory DataModelConverter.fromQuerySnapshot(QuerySnapshot snapshot){
    List<DataModel> data = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
      DataModel dataModel = DataModel.fromJson(map);
      data.add(dataModel);
    }
    return DataModelConverter(data: data);
  }
}