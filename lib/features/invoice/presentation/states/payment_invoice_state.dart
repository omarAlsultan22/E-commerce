import 'package:international_cuisine/core/presentation/states/app_state.dart';
import 'package:international_cuisine/core/data/models/user_info_model.dart';
import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/errors/exceptions/app_exception.dart';


class PaymentInvoiceState {
  final AppState? appState;
  final UserInfoModel? userModel;
  final List<OrderModel>? shoppingList;

  const PaymentInvoiceState({
    this.appState,
    this.userModel,
    this.shoppingList = const [],
  });


  bool get isLoading => appState!.isLoading;

  AppException? get failure => appState!.failure!;


  PaymentInvoiceState copyWith({
    AppState? appState,
    UserInfoModel? userInfo,
    List<OrderModel>? shoppingList
  }) {
    return PaymentInvoiceState(
      appState: appState ?? this.appState,
      userModel: userInfo ?? this.userModel,
      shoppingList: shoppingList ?? this.shoppingList,
    );
  }

  R when<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(List<
        OrderModel>? categoryData, UserInfoModel userModel) onLoaded,
    required R Function(AppException error) onError,
  }) {
    if (failure != null) {
      return onError(failure!);
    }
    if (isLoading) {
      return onLoading();
    }
    if (shoppingList!.isNotEmpty && userModel != null) {
      return onLoaded(shoppingList, userModel!);
    }
    return onInitial();
  }
}



