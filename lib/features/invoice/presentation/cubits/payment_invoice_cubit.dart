import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../states/payment_invoice_state.dart';
import 'package:international_cuisine/core/errors/error_handler.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import 'package:international_cuisine/core/data/models/user_info_model.dart';
import 'package:international_cuisine/core/errors/exceptions/app_exception.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/features/invoice/domain/useCases/payment_Invoice_useCase.dart';


class PaymentInvoiceCubit extends Cubit<PaymentInvoiceState> {
  final CartDataCubit _cubit;
  final PaymentInvoiceUseCase _useCase;

  PaymentInvoiceCubit({
    required CartDataCubit cubit,
    required PaymentInvoiceUseCase useCase
  })
      : _cubit = cubit,
        _useCase = useCase,
        super(PaymentInvoiceState());

  static PaymentInvoiceCubit get(context) => Provider.of(context);


  Future<UserInfoModel> _getUserInfo() async {
    try {
      return _useCase.getInfoExecute();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> _getShoppingList() async {
    return await _cubit.state.getShoppingList;
  }

  Future<void> _sendOrdersToDatabase({
    required UserInfoModel userInfo,
    required List<OrderModel> shoppingList,
  }) async {
    try {
      _useCase.sendDataExecute(userInfo: userInfo, shoppingList: shoppingList);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> displayInvoice() async {
    final appState = state.appState!;
    emit(state.copyWith(
        appState: appState.copyWith(isLoading: true, failure: null)));
    try {
      final userInfo = await _getUserInfo();
      final shoppingList = await _getShoppingList();
      _sendOrdersToDatabase(
          userInfo: userInfo,
          shoppingList: shoppingList
      );
      emit(state.copyWith(
          appState: appState.copyWith(
              isLoading: false
          ),
          userInfo: userInfo,
          shoppingList: shoppingList));
    }
    on AppException catch (e) {
      final exception = ErrorHandler.handleException(e);
      emit(state.copyWith(
          appState: appState.copyWith(isLoading: false, failure: exception)));
    }
  }
}