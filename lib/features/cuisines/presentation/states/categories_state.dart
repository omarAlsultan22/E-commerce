import 'package:international_cuisine/features/cuisines/data/models/categories_success_state.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sup_state.dart';
import 'package:international_cuisine/features/cuisines/data/models/categories_model.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/data_model.dart';


class CategoriesState extends MainAppSupState {
  final MessageResult messageResult;
  final CategoriesModel categoriesModel;

  const CategoriesState({
    required super.subState,
    required this.messageResult,
    required this.categoriesModel
  });

  factory CategoriesState.initial(){
    return CategoriesState(
        subState: InitialState(),
        categoriesModel: CategoriesModel(),
        messageResult: MessageResult.initial()
    );
  }

  bool get hasMore => categoriesModel.hasMore;

  DocumentSnapshot get lastDocument => categoriesModel.lastDocument!;

  List<DataModel> get categoryData => categoriesModel.categoryData!;

  bool get categoryDataIsEmpty => categoryData.isEmpty;

  DataModel currentDataModel(int index) =>
      categoriesModel.currentDataModel(index);

  CategoriesState updateRating({
    required int index,
    required DataModel newModel
  }) {
    final updatedList = List<DataModel>.from(categoryData);
    updatedList[index] = newModel;

    return copyWith(
        categoriesModel: categoriesModel.copyWith(categoryData: updatedList));
  }

  CategoriesModel updateSearchList(List<DataModel> searchData) =>
      categoriesModel.copyWith(searchData: searchData);

  CategoriesState copyWith({
    CategoriesModel? categoriesModel,
    MessageResult? messageResult,
    MainAppSubState? subState
  }) {
    return CategoriesState(
        subState: subState ?? this.subState,
        messageResult: messageResult ?? this.messageResult,
        categoriesModel: categoriesModel ?? this.categoriesModel
    );
  }

  @override
  // TODO: implement dataModels
  CategoriesSuccessState get dataModels =>
      throw
      CategoriesSuccessState(
          messageResult: messageResult,
          categoriesModel: categoriesModel
      );

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(CategoriesSuccessState) onLoaded,
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



