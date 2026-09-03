import 'package:international_cuisine/features/invoice/data/models/payment_Invoice_success_state.dart';
import 'package:international_cuisine/core/presentation/states/base/main_app_sup_state.dart';
import 'package:international_cuisine/core/presentation/states/app_sub_states.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';


class PaymentInvoiceState extends MainAppSupState {
  final UserModel? userModel;
  final List<OrderModel> shoppingList;

  const PaymentInvoiceState({
    this.userModel,
    required super.subState,
    required this.shoppingList,
  });

  factory PaymentInvoiceState.initial(){
    return PaymentInvoiceState(
        userModel: null,
        shoppingList: const [],
        subState: InitialState()
    );
  }

  bool get listIsNotEmpty => shoppingList.isNotEmpty;

  PaymentInvoiceState copyWith({
    UserModel? userModel,
    List<OrderModel>? shoppingList,
    MainAppSubState? subState,
  }) {
    return PaymentInvoiceState(
      subState: subState ?? this.subState,
      userModel: userModel ?? this.userModel,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  @override
  // TODO: implement dataModels
  PaymentInvoiceSuccessState get dataModels =>
      PaymentInvoiceSuccessState(
          userModel: userModel!,
          shoppingList: shoppingList
      );

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(PaymentInvoiceSuccessState) onLoaded,
    required R Function(AppException) onError
  }) {
    return subState.when(
        onInitial: onInitial,
        onLoading: onLoading,
        onLoaded: () =>
            onLoaded.call(dataModels),
        onError: (failure) => onError.call(failure));
  }
}



