import 'package:international_cuisine/features/cart/data/models/order_model.dart';
import '../../../../core/presentation/states/base/main_app_sub_state.dart';
import '../../../../core/presentation/states/base/main_app_sup_state.dart';
import '../../../../core/presentation/states/base/main_loaded_state.dart';
import 'package:international_cuisine/core/data/models/user_model.dart';
import '../../../../core/errors/exceptions/base/app_exception.dart';
import '../../../../core/presentation/states/loaded_states.dart';


class PaymentInvoiceState extends MainAppSupState<UserModel, List<OrderModel>>{
  PaymentInvoiceState({
    super.firstModel,
    super.secondModel,
    required super.subState,
  });

  LoadedState get dataModels =>
      MultiModelSuccessState<UserModel, List<OrderModel>>(
          firstModel: firstModel,
          secondModel: secondModel
      );

  bool get listIsNotEmpty => secondModel!.isNotEmpty;

  @override
  PaymentInvoiceState updateState({
    UserModel? firstModel,
    List<OrderModel>? secondModel,
    MainAppSubState? subState,
  }) {
    return PaymentInvoiceState(
        subState: subState ?? this.subState,
        firstModel: firstModel ?? this.firstModel,
        secondModel: secondModel ?? this.secondModel,
    );
  }

  @override
  R when<R>({
    R Function()? onConnection,
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(LoadedState) onLoaded,
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



