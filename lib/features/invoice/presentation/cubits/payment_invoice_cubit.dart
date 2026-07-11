import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../states/payment_invoice_state.dart';
import '../../../../core/presentation/states/app_sub_states.dart';
import '../../../../core/presentation/mixins/error_handler_mixin.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/cart/presentation/states/cart_data_state.dart';
import 'package:international_cuisine/features/invoice/domain/useCases/payment_Invoice_useCase.dart';


class PaymentInvoiceCubit extends Cubit<PaymentInvoiceState> with ErrorHandlerMixin<PaymentInvoiceState> {
  final CartDataState _cartDataState;
  final PaymentInvoiceUseCase _useCase;
  final ConnectivityProvider _connectivityProvider;

  PaymentInvoiceCubit({
    required CartDataState cartDataState,
    required PaymentInvoiceUseCase useCase,
    required ConnectivityProvider connectivityProvider,
  })
      : _useCase = useCase,
        _cartDataState = cartDataState,
        _connectivityProvider = connectivityProvider,
        super(PaymentInvoiceState.initial()) {
    _startMonitoring();
  }

  static PaymentInvoiceCubit get(context) => Provider.of(context);

  void _startMonitoring() {
    _connectivityProvider.addListener(_handleConnectionChange);
  }

  void _handleConnectionChange() {
    if (_connectivityProvider.isConnected && state.firstModel == null) {
      displayInvoice();
    }
  }

  Future<UserModel?> _getUserInfo() async {
    try {
      return _useCase.getInfoExecute();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> _getShoppingList() async {
    return await _cartDataState.shoppingList;
  }

  Future<void> _sendOrdersToDatabase({
    required UserModel? userInfo,
    required List<OrderModel> shoppingList,
  }) async {
    try {
      _useCase.sendDataExecute(userInfo: userInfo, shoppingList: shoppingList);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> displayInvoice() async {
    if (!_connectivityProvider.isConnected && state.firstModel == null) {
      handleError(
          error: SocketException,
          stackTrace: StackTrace.current,
          onError: (failure) =>
              state.copyWith(
                subState: ErrorState(
                  failure: failure,
                ),
              )
      );
      return;
    }
    emit(
        state.copyWith(
            subState: LoadingState()));
    try {
      final userInfo = await _getUserInfo();
      final shoppingList = await _getShoppingList();

      if (userInfo == null || shoppingList.isEmpty) {
        state.copyWith(subState: InitialState());
        return;
      }

      _sendOrdersToDatabase(
          userInfo: userInfo,
          shoppingList: shoppingList
      );
      emit(
          state.copyWith(
              firstModel: userInfo,
              secondModel: shoppingList,
              subState: SuccessState()));
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

  @override
  Future<void> close() {
    _connectivityProvider.removeListener(_handleConnectionChange);
    return super.close();
  }
}