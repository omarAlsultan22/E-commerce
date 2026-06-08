import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/sign_up_useCase.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/states/message_state.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/constants/app_strings.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_service.dart';


class SignUpCubit extends Cubit<MessageState> with ErrorHandlerMixin<MessageState>{
  final SignUpUseCase _useCase;
  final ConnectivityService _connectivityService;

  SignUpCubit({
    required SignUpUseCase useCase,
    required ConnectivityService connectivityService,

  })
      : _useCase = useCase,
        _connectivityService = connectivityService,
        super(MessageState.initial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String userEmail,
    required String userPassword,
    required String userPhone,
    required String userLocation,
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
      await _useCase.signUpExecute(
        firstName: firstName,
        lastName: lastName,
        userEmail: userEmail,
        userPassword: userPassword,
        userPhone: userPhone,
        userLocation: userLocation,
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