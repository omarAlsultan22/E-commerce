import '../../../../core/data/models/user_model.dart';
import '../../../../core/data/models/message_result.dart';
import 'package:international_cuisine/core/presentation/states/base/main_loaded_state.dart';


class UserInfoSuccessState extends LoadedState {
  final UserModel userModel;
  final MessageResult messageResult;

  const UserInfoSuccessState({
    required this.userModel,
    required this.messageResult
  });
}