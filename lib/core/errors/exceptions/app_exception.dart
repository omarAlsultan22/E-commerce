abstract class AppException implements Exception {
  final String message;
  final bool isConnectionError;
  final StackTrace? stackTrace;

  const AppException({
    this.message = '',
    this.isConnectionError = false,
    this.stackTrace
  });
}