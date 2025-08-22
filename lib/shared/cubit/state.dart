enum StatesKeys{addItem, updateItem, removeItem, clearCart, userInfo, sendOrder, getInfo, updateInfo}

abstract class CubitStates<T>{
  final T?  value;
  final String? error;
  final StatesKeys? stateKey;
  CubitStates({this.value, this.error, this.stateKey});
}

class InitialState extends CubitStates{}
class LoadingState extends CubitStates{
  LoadingState({super.stateKey});
}
class SuccessState<T> extends CubitStates{
  SuccessState({super.value, super.stateKey});
}
class ErrorState extends CubitStates{
  ErrorState({super.error, super.stateKey});
}



