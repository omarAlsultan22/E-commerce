import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/useCases/user_info_useCase.dart';
import '../states/states/update_user_info_state.dart';
import '../../../../core/errors/exceptions/app_exception.dart';
import '../../../../core/data/models/message_result_model.dart';


class UpdateUserInfoCubit extends Cubit<UpdateUserInfoState> {
  final UserInfoUseCase _userInfoUseCase;

  UpdateUserInfoCubit({required UserInfoUseCase userInfoUseCase})
      : _userInfoUseCase = userInfoUseCase,
        super(UpdateUserInfoState());

  static UpdateUserInfoCubit get(context) => BlocProvider.of(context);


  Future<MessageResultModel> updateInfo({
    required String firstName,
    required String lastName,
    required String userPhone,
    required String userLocation
  }) async {

    final appState = state.appState;
    emit(state.updateState(appState: appState!.copyWith(isLoading: true)));

    try {
      await _userInfoUseCase.updateInfoExecute(
        firstName: firstName,
        lastName: lastName,
        userPhone: userPhone,
        userLocation: userLocation,
      );
      return MessageResultModel(isSuccess: true);
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      return MessageResultModel(isSuccess: false, error: exception.message);
    }
  }

  Future<void> getInfo() async {

    final appState = state.appState!;
    emit(state.updateState(appState: appState.copyWith(isLoading: true)));
    try {
      final userModel = await _userInfoUseCase.getInfoExecute();
      emit(state.updateState(
          userModel: userModel, appState: appState.copyWith(isLoading: false)));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.updateState(
          appState: appState.copyWith(isLoading: false, failure: exception)));
    }
  }
}
