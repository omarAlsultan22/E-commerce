import 'package:international_cuisine/core/presentation/states/app_state.dart';
import '../../../../core/errors/exceptions/app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/data_model.dart';


class CategoriesState {
  final bool? hasMore;
  final bool? isConnection;
  final AppState? appState;
  final List<DataModel>? categoryData;
  final List<DataModel>? searchData;
  final DocumentSnapshot? lastDocument;

  const CategoriesState({
    this.appState,
    this.hasMore = true,
    this.isConnection,
    this.categoryData = const [],
    this.searchData = const [],
    this.lastDocument
  });


  bool get isLoading => appState!.isLoading;

  AppException? get failure => appState!.failure!;


  DataModel currentDataModel(int index) => categoryData![index];


  CategoriesState updateRating({
    required int index,
    required DataModel newModel
  }) {
    final updatedList = List<DataModel>.from(categoryData ?? []);
    updatedList[index] = newModel;

    return copyWith(categoryData: updatedList);
  }


  CategoriesState copyWith({
    bool? hasMore,
    bool? isConnection,
    AppState? appState,
    List<DataModel>? categoryData,
    List<DataModel>? searchData,
    DocumentSnapshot? lastDocument
  }) {
    return CategoriesState(
        appState: appState ?? this.appState,
        categoryData: categoryData ?? this.categoryData,
        searchData: searchData ?? this.searchData,
        lastDocument: lastDocument ?? this.lastDocument
    );
  }

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(List<DataModel>? categoryData, List<
        DataModel>? searchData) onLoaded,
    required R Function(AppException error) onError,
  }) {
    if (failure != null) {
      return onError(failure!);
    }
    if (isLoading) {
      return onLoading();
    }
    if (categoryData!.isNotEmpty) {
      return onLoaded(categoryData, searchData);
    }
    return onInitial();
  }
}



