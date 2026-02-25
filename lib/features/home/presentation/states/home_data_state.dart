import 'package:international_cuisine/features/home/data/models/home_model.dart';
import '../../../../core/errors/exceptions/app_exception.dart';
import '../../../../core/presentation/states/app_state.dart';


class HomeDataState{
  final bool? isConnection;
  final AppState? appState;
  final List<HomeDataModel>? homeDataList;

  const HomeDataState({
    this.isConnection,
    this.appState,
    this.homeDataList = const [],
  });

  bool get isLoading => appState!.isLoading;

  AppException? get failure => appState!.failure!;


  HomeDataState copyWith({
    bool? isConnection,
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
    required R Function(AppException error) onError}) {
    if (failure != null) {
      if (isConnection!) {
        return onError(failure!);
      }
      return onError(failure!);
    }
    if (isLoading || homeDataList!.isEmpty) {
      return onLoading();
    }
    return onLoaded(homeDataList!);
  }
}



