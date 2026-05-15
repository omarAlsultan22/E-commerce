import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../states/payment_invoice_state.dart';
import '../../../../core/errors/mappers/error_handler.dart';
import '../../../../core/presentation/states/app_sub_states.dart';
import '../../../../core/errors/exceptions/network_app_exception.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/features/invoice/domain/useCases/payment_Invoice_useCase.dart';


class PaymentInvoiceCubit extends Cubit<PaymentInvoiceState> {
  final CartDataCubit _cubit;
  final PaymentInvoiceUseCase _useCase;
  final ConnectivityProvider _connectivityProvider;

  PaymentInvoiceCubit({
    required CartDataCubit cubit,
    required PaymentInvoiceUseCase useCase,
    required ConnectivityProvider connectivityProvider,
  })
      : _cubit = cubit,
        _useCase = useCase,
        _connectivityProvider = connectivityProvider,
        super(PaymentInvoiceState(subState: InitialState()));

  static PaymentInvoiceCubit get(context) => Provider.of(context);

  void startMonitoring() {
    _connectivityProvider.addListener(_handleConnectionChange);
  }

  void _handleConnectionChange() {
    if (_connectivityProvider.isConnected && state.firstModel == null) {
      displayInvoice();
    }
  }

  Future<UserModel> _getUserInfo() async {
    try {
      return _useCase.getInfoExecute();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> _getShoppingList() async {
    return await _cubit.getData;
  }

  Future<void> _sendOrdersToDatabase({
    required UserModel userInfo,
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
      emit(state.updateState(
        subState: ErrorState(
          failure: NetworkAppException(),
        ),
      ));
      return;
    }
    emit(
        state.updateState(
            subState: LoadingState()));
    try {
      final userInfo = await _getUserInfo();
      final shoppingList = await _getShoppingList();
      _sendOrdersToDatabase(
          userInfo: userInfo,
          shoppingList: shoppingList
      );
      emit(
          state.updateState(
              firstModel: userInfo,
              secondModel: shoppingList,
              subState: SuccessState()));
    }
    catch (e, stackTrace) {
      final errorHandler = ErrorHandler(
          error: e,
          stackTrace: stackTrace
      );
      final exception = errorHandler.handleException();
      emit(
          state.updateState(
              subState: ErrorState(
                  failure: exception
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