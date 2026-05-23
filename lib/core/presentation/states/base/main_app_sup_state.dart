import 'main_loaded_state.dart';
import 'main_app_sub_state.dart';
import '../../../errors/exceptions/base/app_exception.dart';


abstract class MainAppSupState<T, U> extends LoadedState<T, U> {
  final MainAppSubState subState;

  MainAppSupState({
    super.firstModel,
    super.secondModel,
    required this.subState
  });

  LoadedState get dataModels;

  MainAppSupState updateState({
    T? firstModel,
    U? secondModel,
    MainAppSubState? subState
  });

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(LoadedState) onLoaded,
    required R Function(AppException) onError
  });
}