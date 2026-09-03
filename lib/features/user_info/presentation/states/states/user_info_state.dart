import '../../../../../core/data/models/user_model.dart';
import '../../../../../core/errors/exceptions/base/app_exception.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sub_state.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sup_state.dart';
import 'package:international_cuisine/features/user_info/data/models/user_info_success_state.dart';


class UserInfoState extends MainAppSupState {
  final UserModel? userModel;
  final MessageResult messageResult;
  const UserInfoState({
    this.userModel,
    required super.subState,
    required this.messageResult
  });

  factory UserInfoState.initial(){
    return UserInfoState(
        userModel: null,
        messageResult: MessageResult.initial(),
        subState: InitialState()
    );
  }

  UserInfoState copyWith({
    UserModel? userModel,
    MessageResult? messageResult,
    MainAppSubState? subState
  }) {
    return UserInfoState(
      subState: subState ?? this.subState,
      userModel: userModel ?? this.userModel,
      messageResult: messageResult ?? this.messageResult,
    );
  }

  @override
  UserInfoSuccessState get dataModels =>
      UserInfoSuccessState(
          userModel: userModel!,
          messageResult: messageResult
      );

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(UserInfoSuccessState) onLoaded,
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