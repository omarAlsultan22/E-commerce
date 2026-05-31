import 'data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CategoriesModel {
  final bool hasMore;
  final List<DataModel>? searchData;
  final List<DataModel>? categoryData;
  final DocumentSnapshot? lastDocument;

  CategoriesModel({
    this.hasMore = true,
    this.categoryData = const[],
    this.searchData = const[],
    this.lastDocument
  });

  bool get searchDataIsEmpty => searchData!.isEmpty;

  bool get categoryDataIsEmpty => categoryData!.isEmpty;

  DataModel currentDataModel(int index) => categoryData![index];

  CategoriesModel copyWith({
    bool? hasMore,
    List<DataModel>? categoryData,
    List<DataModel>? searchData,
    DocumentSnapshot? lastDocument,
  }) {
    return CategoriesModel(
        hasMore: hasMore ?? this.hasMore,
        searchData: searchData ?? this.searchData,
        categoryData: categoryData ?? this.categoryData,
        lastDocument: lastDocument ?? this.lastDocument
    );
  }
}
