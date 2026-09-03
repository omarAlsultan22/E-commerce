import 'package:international_cuisine/features/home/data/models/home_data_success_state.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sup_state.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';


class HomeDataState extends MainAppSupState {
  final MessageResult messageResult;
  final List<HomeDataModel> homeData;

  const HomeDataState({
    required this.homeData,
    required super.subState,
    required this.messageResult,
  });

  factory HomeDataState.initial(){
    return HomeDataState(
      homeData: const[],
      subState: InitialState(),
      messageResult: MessageResult.initial(),
    );
  }

  bool get dataIsEmpty => homeData.isEmpty;

  HomeDataState copyWith({
    List<HomeDataModel>? homeData,
    MessageResult? messageResult,
    MainAppSubState? subState
  }) {
    return HomeDataState(
      subState: subState ?? this.subState,
      homeData: homeData ?? this.homeData,
      messageResult: messageResult ?? this.messageResult,
    );
  }

  @override
  // TODO: implement dataModels
  HomeDataSuccessState get dataModels =>
      HomeDataSuccessState(
          homeData: homeData,
          messageResult: messageResult
      );

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(HomeDataSuccessState) onLoaded,
    required R Function(AppException) onError
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded(dataModels),
        onError: (failure) => onError(failure));
  }
}