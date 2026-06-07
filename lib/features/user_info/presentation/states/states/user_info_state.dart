import '../../../../../core/data/models/user_model.dart';
import '../../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/core/presentation/states/app_sup_states.dart';
import 'package:international_cuisine/core/presentation/states/base/main_loaded_state.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sub_state.dart';


class UserInfoState extends DoubleModelAppState<UserModel, MessageResult> {
  UserInfoState({
    super.firstModel,
    super.secondModel,
    required super.subState,
  });

  factory UserInfoState.initial(){
    return UserInfoState(
        firstModel: null,
        secondModel: MessageResult.initial(),
        subState: InitialState()
    );
  }

  UserModel? get userModel => firstModel;

  @override
  UserInfoState copyWith({
    UserModel? firstModel,
    MessageResult? secondModel,
    MainAppSubState? subState
  }) {
    return UserInfoState(
      subState: subState ?? this.subState,
      firstModel: firstModel ?? this.firstModel,
      secondModel: secondModel ?? this.secondModel,
    );
  }

  @override
  R when<R>({
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