import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';


class PaginatedResult {
  final List<DataModel> dataList;
  final DocumentSnapshot? lastDocument;
  final bool hasMoreData;

  PaginatedResult({
    required this.dataList,
    required this.lastDocument,
    required this.hasMoreData,
  });
}