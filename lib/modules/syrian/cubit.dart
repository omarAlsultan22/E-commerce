import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../modles/data_model.dart';

class SyrianCubit extends Cubit<CubitStates>{
  SyrianCubit() : super(InitialState());

  static SyrianCubit get(context) => BlocProvider.of(context);

  List<DataModel> dataModelList = [];

  Future<void> getData() async {
    emit(LoadingState());
    dataModelList.clear();
    final firebase = FirebaseFirestore.instance;
    await firebase.collection('countriesData').doc('L8nSAa05FTdy6I47cOaf')
        .collection('syrian').get()
        .then((value) {
      DataList dataList = DataList.fromQuerySnapshot(value);
      dataModelList = dataList.data;
      emit((SuccessState()));
    }).catchError((error) {
      emit(ErrorState(error));
    });
  }

  Future<void> updateData({
    required String index,
    required String orderImage,
    required String orderName,
    required int likesNumber,
    required int dislikesNumber,
    required int orderPrice,
    required int rating

  }) async {
    emit(LoadingState());
    final firebase = FirebaseFirestore.instance;
    DataModel dataModel = DataModel(
      orderImage: orderImage,
      orderName: orderName,
      orderPrice: orderPrice,
      rating: rating
    );
    await firebase.collection('countriesData').doc('L8nSAa05FTdy6I47cOaf')
        .collection('syrian').doc(index).update(dataModel.toMap()).then((_) {
      emit((SuccessState()));
    }).catchError((error) {
      emit(ErrorState(error));
    });
  }
}