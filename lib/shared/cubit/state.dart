import '../constants/state_keys.dart';

abstract class CubitStates<T>{
  final T?  value;
  final String? error;
  final StatesKeys? stateKey;
  CubitStates({this.value, this.error, this.stateKey});
}

class InitialState<T> extends CubitStates<T>{
  InitialState() : super();
}
class LoadingState<T> extends CubitStates<T>{
  LoadingState({super.stateKey});
}
class SuccessState<T> extends CubitStates{
  SuccessState({super.value, super.stateKey});
}
class ErrorState<T> extends CubitStates<T>{
  ErrorState({super.error, super.stateKey});
}



