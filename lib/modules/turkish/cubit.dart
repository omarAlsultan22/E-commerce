import 'package:international_cuisine/shared/components/components.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:international_cuisine/modles/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../modles/units_processes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TurkishCubit extends Cubit<CubitStates> implements UnitsProcessesModel{
  TurkishCubit() : super(InitialState());

  static TurkishCubit get(context) => BlocProvider.of(context);

  List<DataModel> dataModelList = [];
  List<DataModel> searchData = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = true;
  bool _isLoading = false;

  @override
  Future<void> getData() async {
    if (_isLoading || isLoadingMore == false) return;
    _isLoading = true;
    emit(LoadingState());

    try {
      final dataList = await getCountriesData(
          lastDocument: lastDocument,
          collectionId: 'turkish',
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

  @override
  Future<void> getDataSearch(String searchText) async {
    emit(LoadingState());
    try {
      final _filteredData = await fetchPartialMatch(
          query: searchText, collectionId: 'turkish');

      searchData = _filteredData;
      emit(SuccessState());
    }
    catch (e) {
      emit(ErrorState(error: e.toString()));
    }
  }

  @override
  void clearSearch() {
    searchData.clear();
    emit(InitialState());
  }

  @override
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