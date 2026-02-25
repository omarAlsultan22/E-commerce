import '../../domain/useCases/auth_useCase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../core/data/models/message_result_model.dart';
import '../../../../../core/errors/exceptions/app_exception.dart';
import 'package:international_cuisine/core/errors/auth_error_handler.dart';


class AuthOperations {
  final AuthUseCase _authUseCase;

  AuthOperations({required AuthUseCase authUseCase})
      : _authUseCase = authUseCase;

  Future<MessageResultModel> signIn({
    required String userEmail,
    required String userPassword,
  }) async {
    try {
      if (userEmail.isEmpty || userPassword.isEmpty) {
        throw('Fields cannot be empty.');
      }
      await _authUseCase.signInExecute(
          userEmail: userEmail,
          userPassword: userPassword
      );

      return MessageResultModel(isSuccess: true);
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      return MessageResultModel(isSuccess: false, error: exception.message);
    }
  }


  Future<MessageResultModel> signUp({
    required String firstName,
    required String lastName,
    required String userEmail,
    required String userPassword,
    required String userPhone,
    required String userLocation,
  }) async {
    try {
      await _authUseCase.signUpExecute(
        firstName: firstName,
        lastName: lastName,
        userEmail: userEmail,
        userPassword: userPassword,
        userPhone: userPhone,
        userLocation: userLocation,
      );

      return MessageResultModel(isSuccess: true);
    } on FirebaseAuthException catch (e) {
      final message = AuthErrorHandler.handleAuthError(e);
      return MessageResultModel(isSuccess: false, error: message);
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      return MessageResultModel(isSuccess: false, error: exception.message);
    }
  }


  Future<MessageResultModel> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _authUseCase.updateProfileExecute(
          newEmail: newEmail,
          newPassword: newPassword,
          currentPassword: currentPassword
      );
      return MessageResultModel(isSuccess: true);
    } on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      return MessageResultModel(isSuccess: false, error: exception.message);
    }
  }
}