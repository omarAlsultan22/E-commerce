import 'package:international_cuisine/features/invoice/data/repositories_impl/firestore_payment_invoice_repository.dart';
import 'package:international_cuisine/features/invoice/presentation/widgets/layouts/payment_invoice_layout.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push_replacement.dart';
import 'package:international_cuisine/features/invoice/domain/useCases/payment_Invoice_useCase.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/features/home/presentation/screens/home_screen.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import 'package:international_cuisine/core/presentation/states/loaded_states.dart';
import '../../../../core/presentation/widgets/states/loading_state_widget.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';
import '../../../../core/presentation/widgets/appbar_widget.dart';
import '../../../../core/data/data_sources/remote/firestore.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/payment_invoice_cubit.dart';
import '../states/payment_invoice_state.dart';
import 'package:flutter/material.dart';


class PaymentInvoiceScreen extends StatelessWidget {
  final bool isPaid;

  const PaymentInvoiceScreen({required this.isPaid, super.key});

  @override
  Widget build(BuildContext context) {
    final _cacheHelper = CacheHelper();
    final _repository = FirestoreService();
    final _cartState = CartDataCubit
        .get(context)
        .state;
    final _userInfoRepository = FirestorePaymentInvoiceRepository(
        repository: _repository, cacheHelper: _cacheHelper);
    final _useCase = PaymentInvoiceUseCase(
        userInfoRepository: _userInfoRepository);
    final _connectivityProvider = ConnectivityProvider();

    void _stateListener(PaymentInvoiceState state) {
      if (state.listIsNotEmpty) {
        QuickAlert.show(
          context: context,
          title: 'تم ارسال طلبك بنجاح!',
          text: 'قم بأخذ لقطة شاشة للفتورة',
          type: QuickAlertType.success,
          showConfirmBtn: true,
          confirmBtnText: 'حسنا',
        );
      }
    }

    Widget _initialState() {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
                leading: BackButtonWidget(
                    color: AppColors.mediumGrey600,
                    onPressed: () =>
                        BuildNavigatorPushReplacement.build(
                            context: context, link: HomeScreen()
                        )
                )
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                      Icons.shopping_bag_outlined, size: 80.0,
                      color: AppColors.lightGrey400),
                  AppSpaces.verticalSpacing_16,
                  Text(
                    'لا توجد طلبات للتوصيل',
                    style: TextStyle(
                        fontSize: AppSizes.fontSize18,
                        color: AppColors.grey),
                  ),
                  AppSpaces.verticalSpacing_8,
                  const Text(
                    'يمكنك تصفح المطاعم وإضافة طلبات جديدة',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.mediumGrey600),
                  ),
                ],
              ),
            ),
          )
      );
    }

    return BlocProvider(create: (context) =>
    PaymentInvoiceCubit(cartDataState: _cartState,
        useCase: _useCase,
        connectivityProvider: _connectivityProvider)
      ..displayInvoice(),
        child: BlocConsumer<PaymentInvoiceCubit, PaymentInvoiceState>(
            listener: (context, state) {
              _stateListener(state);
            },
            builder: (context, state) {
              final _cubit = PaymentInvoiceCubit.get(context);
              return state.when(
                  onInitial: () => _initialState(),
                  onLoading: () => LoadingStateWidget(),
                  onLoaded: (loadedState) {
                    final data = loadedState as DoubleModelSuccessState;
                    return PaymentInvoiceLayout(
                      isPaid: isPaid,
                      userInfoModel: data.firstModel,
                      shoppingList: data.secondModel,
                    );
                  },
                  onError: (error) =>
                      error.buildErrorWidget(
                          appBar: AppbarWidget.build(context),
                          onRetry: () => _cubit.displayInvoice())
              );
            }
        )
    );
  }
}


