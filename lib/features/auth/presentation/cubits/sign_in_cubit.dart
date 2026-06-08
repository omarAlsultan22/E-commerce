import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/sign_in_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class SignInCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState>{
  final SignInUseCase _useCase;
  final ConnectivityService _connectivityService;

  SignInCubit({
    required SignInUseCase useCase,
    required ConnectivityService connectivityService
  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(MessageState.initial());

  static SignInCubit get(context) => BlocProvider.of(context);

  Future<void> signIn({
    required String userEmail,
    required String userPassword,
  }) async {
    final _isConnected = await _connectivityService.checkInternetConnection();
    if (!_isConnected) {
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
      if (userEmail.isEmpty || userPassword.isEmpty) {
        throw('Fields cannot be empty.');
      }
      _useCase.signInExecute(
          userEmail: userEmail,
          userPassword: userPassword
      );
      emit(MessageState(
          messageResult: MessageResult.success()));
    } catch (e, stackTrace) {
      handleError(e, stackTrace,
          onError: (failure) =>
              MessageState(messageResult: MessageResult.error(error: failure)
              )
      );
    }
  }
}