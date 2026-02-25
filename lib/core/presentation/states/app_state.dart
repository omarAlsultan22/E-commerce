import 'base/when_states.dart';
import '../../errors/exceptions/app_exception.dart';


class AppState implements WhenStates{
  final bool isLoading;
  final AppException? failure;

  const AppState({
    this.isLoading = true,
    this.failure,
  });

  AppState copyWith({
    bool? isLoading,
    AppException? failure,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function() onLoaded,
    required R Function(AppException error) onError,
  }) {
    if (failure != null) {
      return onError(failure!);
    }

    if (isLoading) {
      return onLoading();
    }

    if (!isLoading) {
      return onLoaded();
    }

    return onInitial();
  }
}

