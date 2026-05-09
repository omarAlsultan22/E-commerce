import '../states/cart_data_state.dart';
import '../../data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/cart_data_useCase.dart';
import '../../../cuisines/data/models/data_model.dart';
import 'package:international_cuisine/core/errors/error_handler.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/core/errors/exceptions/base/app_exception.dart';


class CartDataCubit extends Cubit<CartDataState> {
  final CartDataUseCase _useCase;

  CartDataCubit({
    required CartDataUseCase useCase
  })
      :
        _useCase = useCase,
        super(
          CartDataState(
              firstModel: [],
              subState: InitialState()));

  static CartDataCubit get(context) => BlocProvider.of(context);

  List<OrderModel> get getData => state.getShoppingList;

  Future<void> addOrder({
    required String orderSize,
    required DataModel dataModel,
  }) async {
    final orderModel = OrderModel(
      order: '${dataModel.orderName} ${orderSize}',
      image: dataModel.orderImage!,
      price: dataModel.orderPrice!,
      item: dataModel.selectedItem,
    );
    final shoppingList = state.addOrder(
        dataModel: dataModel, orderModel: orderModel);
    emit(state.updateState(firstModel: shoppingList));
  }

  void removeItem(int index) {
    try {
      state.removeItem(index);
      _useCase.removeItemExecute(index: index);
      emit(state.updateState());
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.updateState(subState: ErrorState(failure: failure)));
    }
  }

  void updateItemQuantity(int index, int newQuantity) {
    final shoppingList = state.updateItemQuantity(index, newQuantity);
    emit(state.updateState(firstModel: shoppingList));
  }

  int getTotalPrice() {
    return state.getTotalPrice();
  }

  Future<void> saveCartToHive() async {
    try {
      await _useCase.saveCartDataExecute(shoppingList: state.getShoppingList);
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.updateState(subState: ErrorState(failure: failure)));
    }
  }

  Future<void> getCartData() async {
    emit(state.updateState(subState: LoadingState()));
    try {
      final shoppingList = await _useCase.getCartDataExecute();
      if (shoppingList.isEmpty) {
        emit(state.updateState(subState: InitialState()));
      }
      emit(state.updateState(
          firstModel: shoppingList, subState: SuccessState()));
    }
    on AppException catch (e) {
      final failure = ErrorHandler.handleException(e);
      emit(state.updateState(subState: ErrorState(failure: failure)));
    }
  }
}

