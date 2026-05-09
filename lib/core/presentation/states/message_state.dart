import 'package:international_cuisine/core/data/models/message_result.dart';


class AuthState {
  final bool? isConnected;
  final MessageResult? messageResult;

  const AuthState({
    this.isConnected,
    this.messageResult
  });

  AuthState updateState({
    bool? isConnected,
    MessageResult? messageResult
  }) {
    return AuthState(
        isConnected: isConnected ?? this.isConnected,
        messageResult: messageResult ?? this.messageResult
    );
  }
}