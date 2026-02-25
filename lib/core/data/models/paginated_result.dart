import 'package:cloud_firestore/cloud_firestore.dart';


class PaginatedResult<T> {
  final List<T> data;
  final DocumentSnapshot? lastDocument;
  final bool hasMoreData;

  PaginatedResult({
    required this.data,
    required this.lastDocument,
    required this.hasMoreData,
  });
}