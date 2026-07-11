import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../domain/useCases/change_email_and_password_useCase.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:international_cuisine/core/errors/exceptions/network_app_exception.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class ChangeEmailAndPasswordCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState> {
  final ChangeEmailAndPasswordUseCase _useCase;
  final ConnectivityService _connectivityService;

  ChangeEmailAndPasswordCubit({
    required ChangeEmailAndPasswordUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(MessageState.initial());

  static ChangeEmailAndPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    final _isConnected = await _connectivityService.checkInternetConnection();
    if (!_isConnected) {
      emit(
        MessageState(
          messageResult: MessageResult.error(
              error: NetworkAppException(
                  message: AppStrings.noInternetMessage)),
        ),
      );
      return;
    }
    emit(MessageState(messageResult: MessageResult.loading()));
    try {
      _useCase.updateProfileExecute(
          newEmail: newEmail,
          newPassword: newPassword,
          currentPassword: currentPassword
      );
      emit(
          MessageState(messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              MessageState(messageResult: MessageResult.error(error: failure)
              )
      );
    }
  }
}