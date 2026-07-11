import 'package:international_cuisine/features/cuisines/data/models/categories_model.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/core/presentation/states/app_sup_states.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/presentation/states/base/main_loaded_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/data_model.dart';


class CategoriesState extends DoubleModelAppState<CategoriesModel, MessageResult> {
  CategoriesState({
    super.firstModel,
    super.secondModel,
    required super.subState,
  });

  factory CategoriesState.initial(){
    return CategoriesState(
        firstModel: CategoriesModel(),
        secondModel: MessageResult.initial(),
        subState: InitialState()
    );
  }

  bool get hasMore => firstModel!.hasMore;

  DocumentSnapshot get lastDocument => firstModel!.lastDocument!;

  List<DataModel> get categoryData => firstModel!.categoryData!;

  bool get categoryDataIsEmpty => categoryData.isEmpty;

  DataModel currentDataModel(int index) => firstModel!.currentDataModel(index);

  CategoriesState updateRating({
    required int index,
    required DataModel newModel
  }) {
    final updatedList = List<DataModel>.from(categoryData);
    updatedList[index] = newModel;

    return copyWith(
        firstModel: firstModel!.copyWith(categoryData: updatedList));
  }

  CategoriesModel updateSearchList(List<DataModel> searchData) =>
      firstModel!.copyWith(searchData: searchData);

  @override
  CategoriesState copyWith({
    CategoriesModel? firstModel,
    MessageResult? secondModel,
    MainAppSubState? subState
  }) {
    return CategoriesState(
      subState: subState ?? this.subState,
      firstModel: firstModel ?? this.firstModel,
      secondModel: secondModel ?? this.secondModel
    );
  }

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(LoadedState) onLoaded,
    required R Function(AppException) onError
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded.call(dataModels),
        onError: (failure) => onError.call(failure));
  }
}



