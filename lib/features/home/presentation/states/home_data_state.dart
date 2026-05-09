import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/presentation/states/base/main_app_sup_state.dart';
import '../../../../core/presentation/states/base/main_loaded_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';


class HomeDataState extends MainAppSupState<List<HomeDataModel>, Never>{
  HomeDataState({
    super.firstModel,
    super.secondModel,
    required super.subState,
  });

  LoadedState get dataModels =>
      SingleModelSuccessState<List<HomeDataModel>>(
          firstModel: firstModel,
      );

  bool get dataISEmpty => firstModel!.isEmpty;

  @override
  HomeDataState updateState({
    List<HomeDataModel>? firstModel,
    Never? secondModel,
    bool? isConnected,
    MainAppSubState? subState
  }) {
    return HomeDataState(
        subState: subState ?? this.subState,
        firstModel: firstModel ?? this.firstModel,
        secondModel: secondModel ?? this.secondModel,
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