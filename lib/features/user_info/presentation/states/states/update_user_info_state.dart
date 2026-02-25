import '../../../../../core/data/models/user_info_model.dart';
import '../../../../../core/presentation/states/app_state.dart';
import '../../../../../core/errors/exceptions/app_exception.dart';
import '../../../../../core/presentation/states/base/when_states.dart';


class UpdateUserInfoState implements WhenStates {
  final UserInfoModel? userModel;
  final AppState? appState;

  UpdateUserInfoState({this.userModel, this.appState});

  String get firstName => userModel!.firstName;

  String get lastName => userModel!.lastName;

  String get userPhone => userModel!.userPhone;

  String? get userLocation => userModel!.userLocation;

  bool get isLoading => appState!.isLoading;

  AppException? get failure => appState!.failure;

  UpdateUserInfoState updateState({
    UserInfoModel? userModel,
    AppState? appState
  }) {
    return UpdateUserInfoState(
        userModel: userModel ?? this.userModel,
        appState: appState ?? this.appState
    );
  }


  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException error) onError}) {
    if (failure != null) {
      return onError(failure!);
    }

    if (isLoading) {
      return onLoading();
    }

    if (!isLoading && userModel != null) {
      return onLoaded();
    }

    return onInitial();
  }
}