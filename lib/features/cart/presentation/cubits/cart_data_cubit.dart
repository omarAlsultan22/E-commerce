import '../states/cart_data_state.dart';
import '../../data/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/useCases/cart_data_useCase.dart';
import '../../../cuisines/data/models/data_model.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';


class CartDataCubit extends Cubit<CartDataState> with ErrorHandlerMixin<CartDataState> {
  final CartDataUseCase _useCase;

  CartDataCubit({
    required CartDataUseCase useCase
  })
      :
        _useCase = useCase,
        super(
          CartDataState.initial());

  static CartDataCubit get(context) => BlocProvider.of(context);

  List<OrderModel> get getData => state.shoppingList;

  void _checkListIsEmpty(List<OrderModel> shoppingList) {
    if (shoppingList.isEmpty) {
      emit(state.copyWith(subState: InitialState()));
      return;
    }
  }

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
        dataModel: dataModel, orderModel: orderModel
    );

    _checkListIsEmpty(shoppingList);

    print(shoppingList.length);
    emit(
        state.copyWith(
            firstModel: shoppingList,
            subState: SuccessState()
        )
    );
  }

  void removeItem(int index) {
    try {
      state.removeItem(index);
      _useCase.removeItemExecute(index: index);
      _checkListIsEmpty(state.shoppingList);
      emit(state.copyWith());
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      failure: failure
                  )
              )
      );
    }
  }

  void updateItemQuantity(int index, int newQuantity) {
    final shoppingList = state.updateItemQuantity(index, newQuantity);
    emit(state.copyWith(firstModel: shoppingList));
  }

  int getTotalPrice() {
    return state.getTotalPrice();
  }

  Future<void> saveCartToHive() async {
    try {
      await _useCase.saveCartDataExecute(shoppingList: state.shoppingList);
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      failure: failure
                  )
              )
      );
    }
  }

  Future<void> getCartData() async {
    emit(state.copyWith(subState: LoadingState()));
    try {
      final shoppingList = await _useCase.getCartDataExecute();

      _checkListIsEmpty(shoppingList);

      emit(state.copyWith(
          firstModel: shoppingList, subState: SuccessState()));
    }
    catch (e, stackTrace) {
      handleError(
          error: e,
          stackTrace: stackTrace,
          onError: (failure) =>
              state.copyWith(
                  subState: ErrorState(
                      failure: failure
                  )
              )
      );
    }
  }
}

