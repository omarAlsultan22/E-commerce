import 'package:international_cuisine/features/home/data/models/home_model.dart';
import '../../../../core/errors/exceptions/app_exception.dart';
import '../../../../core/presentation/states/app_state.dart';

class HomeDataState {
  final AppState appState;
  final List<HomeDataModel> homeDataList;

  const HomeDataState({
    required this.appState,
    required this.homeDataList,
  });

  bool get isLoading => appState.isLoading;

  AppException? get failure => appState.failure;

  HomeDataState copyWith({
    final AppState? appState,
    List<HomeDataModel>? homeDataList,
  }) {
    return HomeDataState(
      appState: appState ?? this.appState,
      homeDataList: homeDataList ?? this.homeDataList,
    );
  }

  R when<R>({
    required R Function() onLoading,
    required R Function(List<HomeDataModel> data) onLoaded,
    required R Function(AppException error) onError,
  }) {
    if (failure != null) {
      return onError(failure!);
    }

    if (isLoading) {
      return onLoading();
    }

    return onLoaded(homeDataList);
  }
}