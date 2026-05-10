import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/errors/exceptions/network_exception.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import '../../../../core/errors/exceptions/security_exception.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class ForgetPasswordCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final ConnectivityService _connectivityService;

  ForgetPasswordCubit({
    required AuthRepository repository,
    required ConnectivityService connectivityService
  })
      : _repository = repository,
        _connectivityService = connectivityService,
        super(const AuthState());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  Future<void> sendResetEmail({
    required String userEmail
  }) async {
    final isConnected = await _connectivityService.checkInternetConnection();
    if (!isConnected) {
      emit(
        AuthState(
          messageResult: MessageResult.error(
              error: NetworkException(message: AppStrings.noInternetMessage)),
        ),
      );
      return;
    }
    emit(AuthState(messageResult: MessageResult.loading()));
    try {
      if (userEmail.isEmpty) {
        emit(
            AuthState(
              messageResult: MessageResult.error(
                  error: SecurityException(
                      message: 'الرجاء إدخال بريدك الإلكتروني')),
            )
        );
      }
      _repository.sendResetEmail(
        userEmail: userEmail,
      );
      emit(AuthState(
          messageResult: MessageResult.success(
              message: 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني')));
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(AuthState(messageResult: MessageResult.error(error: exception)));
    }
  }
}