import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modles/home_model.dart';

class HomeCubit extends Cubit<CubitStates> {
  HomeCubit() : super(InitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<HomeModel> dataModelList = [];

  Future<void> getData() async {
    emit(LoadingState());
    dataModelList.clear();
    final firebase = FirebaseFirestore.instance;
    await firebase.collection('homeData').get()
        .then((value) {
      HomeList dataList = HomeList.fromQuerySnapshot(value);
      dataModelList = dataList.data;
      emit((SuccessState()));
    }).catchError((error) {
      emit(ErrorState(error: error));
    });
  }
}