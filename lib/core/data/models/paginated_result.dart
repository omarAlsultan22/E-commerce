import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';


class PaginatedResult {
  final bool hasMoreData;
  final List<DataModel> dataList;
  final DocumentSnapshot? lastDocument;

  PaginatedResult({
    required this.dataList,
    required this.lastDocument,
    required this.hasMoreData,
  });

  bool get isEmpty => dataList.isEmpty;
}