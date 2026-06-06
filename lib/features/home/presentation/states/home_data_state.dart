import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/core/presentation/states/app_sup_states.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/presentation/states/base/main_loaded_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';


class HomeDataState extends SingleModelAppState<List<HomeDataModel>>{
  HomeDataState({
    super.firstModel,
    required super.subState,
  });

  factory HomeDataState.initial(){
    return HomeDataState(
        firstModel: null,
        subState: InitialState()
    );
  }

  bool get dataISEmpty => firstModel!.isEmpty;

  @override
  HomeDataState copyWith({
    MainAppSubState? subState,
    List<HomeDataModel>? firstModel
  }) {
    return HomeDataState(
        subState: subState ?? this.subState,
        firstModel: firstModel ?? this.firstModel,
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