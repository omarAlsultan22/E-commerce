abstract class CubitStates{}
class InitialState extends CubitStates{}
class LoadingState extends CubitStates{}
class SuccessState<T> extends CubitStates{
  final T? value;
  SuccessState({this.value});
}
class ErrorState extends CubitStates{
  String error;
  ErrorState(this.error);
}



