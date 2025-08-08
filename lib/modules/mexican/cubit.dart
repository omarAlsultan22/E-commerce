import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../modles/data_model.dart';
import '../../shared/components/components.dart';

class MexicanCubit extends Cubit<CubitStates> {
  MexicanCubit() : super(InitialState());

  static MexicanCubit get(context) => BlocProvider.of(context);

  List<DataModel> dataModelList = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = true;

  Future<void> getData() async {
    emit(LoadingState());
    await getCountriesData(
        dataModelList: dataModelList,
        lastDocument: lastDocument,
        collectionId: 'mexican',
        isLoadingMore: isLoadingMore
    ).then((dataList) {
      dataModelList.addAll(dataList);
      emit((SuccessState()));
    }).catchError((e) {
      emit(ErrorState(e.toString()));
    });
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