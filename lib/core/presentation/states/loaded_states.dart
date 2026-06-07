import 'base/main_loaded_state.dart';


class SingleModelSuccessState<T> extends LoadedState {
  T? firstModel;

  SingleModelSuccessState({
    required this.firstModel
  });
}


class DoubleModelSuccessState<T, U> extends LoadedState {
  T? firstModel;
  U? secondModel;

  DoubleModelSuccessState({
    required this.firstModel,
    required this.secondModel
  });
}





