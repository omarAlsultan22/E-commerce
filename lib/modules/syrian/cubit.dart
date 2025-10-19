import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modles/data_model.dart';


class SyrianCubit extends Cubit<CubitStates>{
  SyrianCubit() : super(InitialState());

  static SyrianCubit get(context) => BlocProvider.of(context);

  List<DataModel> dataModelList = [];
  List<DataModel> searchData = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = true;
  bool _isLoading = false;

  Future<void> getData() async {
    if (_isLoading || isLoadingMore == false) return;
    _isLoading = true;
    emit(LoadingState());

    try {
      final dataList = await getCountriesData(
          lastDocument: lastDocument,
          collectionId: 'syrian',
          updateLastDoc: (lastDoc) => lastDocument = lastDoc
      );

      if (dataList.isEmpty) {
        isLoadingMore = false;
      } else {
        dataModelList.addAll(dataList);
      }
      emit(SuccessState());
    } catch (e) {
      isLoadingMore = false;
      emit(ErrorState(error: e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> getDataSearch(String searchText) async {
    emit(LoadingState());
    try {
      final _filteredData = await fetchPartialMatch(
          query: searchText, collectionId: 'syrian');

      searchData = _filteredData;
      emit(SuccessState());
    }
    catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  void clearSearch() {
    searchData.clear();
    emit(InitialState());
  }

  Future<void> updateData({
    required String collectionId,
    required String index,
    required int rating
  }) async {
    emit(LoadingState());
    updateDataModel(
        collectionId: collectionId,
        index: index,
        rating: rating
    ).then((_) {
      emit(SuccessState());
    }).catchError((error) {
      emit(ErrorState(error: error));
    });
  }
}