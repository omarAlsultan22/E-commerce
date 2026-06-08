import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import '../../../../core/errors/exceptions/security_app_exception.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class ForgetPasswordCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState>{
  final AuthRepository _repository;
  final ConnectivityService _connectivityService;

  ForgetPasswordCubit({
    required AuthRepository repository,
    required ConnectivityService connectivityService
  })
      : _repository = repository,
        _connectivityService = connectivityService,
        super(MessageState.initial());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> sendResetEmail({
    required String userEmail
  }) async {
    final isConnected = await _connectivityService.checkInternetConnection();
    if (!isConnected) {
      emit(
        MessageState(
          messageResult: MessageResult.error(
              error: NetworkAppException(message: AppStrings.noInternetMessage)),
        ),
      );
      return;
    }
    emit(MessageState(messageResult: MessageResult.loading()));
    try {
      if (userEmail.isEmpty) {
        emit(
            MessageState(
              messageResult: MessageResult.error(
                  error: SecurityAppException(
                      message: 'الرجاء إدخال بريدك الإلكتروني')),
            )
        );
      }
      _repository.sendResetEmail(
        userEmail: userEmail,
      );
      emit(MessageState(
          messageResult: MessageResult.success(
              message: 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني')));
    } catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              MessageState(messageResult: MessageResult.error(error: failure)
              )
      );
    }
  }
}