import '../states/cart_data_state.dart';
import '../../data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/cart_data_useCase.dart';
import '../../../cuisines/data/models/data_model.dart';
import 'package:international_cuisine/core/errors/error_handler.dart';
import '../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/core/presentation/states/app_state.dart';
import 'package:international_cuisine/core/errors/exceptions/app_exception.dart';


class CartDataCubit extends Cubit<CartDataState> {
  final CartDataUseCase _useCase;

  CartDataCubit({
    required CartDataUseCase useCase
  })
      :
        _useCase = useCase,
        super(CartDataState(
          appState: AppState(),
          shoppingList: const []));

  static CartDataCubit get(context) => BlocProvider.of(context);

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
    emit(state.copyWith(shoppingList: shoppingList));
  }


  void removeItem(int index) {
    final appState = state.appState!;
    try {
      state.removeItem(index);
      _useCase.removeItemExecute(index: index);
      emit(state.copyWith());
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.copyWith(appState: appState.copyWith(failure: exception)));
    }
  }


  void updateItemQuantity(int index, int newQuantity) {
    final shoppingList = state.updateItemQuantity(index, newQuantity);
    emit(state.copyWith(shoppingList: shoppingList));
  }


  void clearCart() {
    final appState = state.appState!;
    try {
      state.clearCart();
      _useCase.clearCartExecute();
      emit(state.copyWith());
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.copyWith(appState: appState.copyWith(failure: exception)));
    }
  }


  int getTotalPrice() {
    return state.getTotalPrice();
  }

  Future<void> saveCartToHive() async {
    final appState = state.appState!;
    try {
      await _useCase.saveCartDataExecute(shoppingList: state.getShoppingList);
      await CacheHelper.setIntValue(key: 'cart_saved_time', value: DateTime
          .now()
          .millisecondsSinceEpoch);
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.copyWith(appState: appState.copyWith(failure: exception)));
    }
  }

  Future<void> getCartData() async {
    final appState = state.appState!;
    try {
      final shoppingList = await _useCase.getCartDataExecute();
      emit(state.copyWith(shoppingList: shoppingList,
          appState: appState.copyWith(isLoading: false)));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.copyWith(
          appState: appState.copyWith(failure: exception, isLoading: false)));
    }
  }
}

