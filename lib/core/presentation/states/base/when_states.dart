import '../../../errors/exceptions/app_exception.dart';


abstract class WhenStates{
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException error) onError,
  });
}