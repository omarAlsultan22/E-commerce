import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modles/data_model.dart';
import 'package:international_cuisine/shared/components/components.dart';
import 'package:international_cuisine/shared/cubit/state.dart';

class ChineseCubit extends Cubit<CubitStates> {
  ChineseCubit() : super(InitialState());

  static ChineseCubit get(context) => BlocProvider.of(context);

  List<DataModel> dataModelList = [];
  List<DataModel> searchData = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = true;

  Future<void> getData() async {
    emit(LoadingState());
    await getCountriesData(
        dataModelList: dataModelList,
        lastDocument: lastDocument,
        collectionId: 'chinese',
        isLoadingMore: isLoadingMore
    ).then((dataList) {
      dataModelList.addAll(dataList);
      emit((SuccessState()));
    }).catchError((e) {
      emit(ErrorState(e.toString()));
    });
  }

  Future<void> getDataSearch(String searchText) async {
    final _filteredData = await fetchPartialMatch(query: searchText, collectionId: 'chinese');
    searchData = _filteredData;
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
      emit(ErrorState(error));
    });
  }
}