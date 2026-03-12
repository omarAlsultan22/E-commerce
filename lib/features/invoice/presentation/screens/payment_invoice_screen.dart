import 'package:international_cuisine/features/invoice/data/repositories_impl/firestore_payment_invoice_repository.dart';
import 'package:international_cuisine/features/invoice/presentation/widgets/layouts/payment_invoice_layout.dart';
import 'package:international_cuisine/features/invoice/domain/useCases/payment_Invoice_useCase.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import '../../../../core/presentation/widgets/states/loading_state_widget.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/payment_invoice_cubit.dart';
import '../states/payment_invoice_state.dart';
import 'package:flutter/material.dart';


class PaymentInvoiceScreen extends StatelessWidget {
  final bool isPaid;

  const PaymentInvoiceScreen({required this.isPaid, super.key});

  @override
  Widget build(BuildContext context) {
    final _cartCubit = context.read<CartDataCubit>();
    final _repository = FirebaseFirestore.instance;
    final _userInfoRepository = FirestorePaymentInvoiceRepository(
        repository: _repository);
    final _useCase = PaymentInvoiceUseCase(
        userInfoRepository: _userInfoRepository);

    void _stateListener(PaymentInvoiceState state) {
      if (!state.isLoading && state.listIsNotEmpty) {
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

    return ConnectivityAwareService(
        child: BlocProvider(create: (context) =>
        PaymentInvoiceCubit(cubit: _cartCubit, useCase: _useCase)
          ..displayInvoice(),
            child: BlocConsumer<PaymentInvoiceCubit, PaymentInvoiceState>(
                listener: (context, state) {
                  _stateListener(state);
                },
                builder: (context, state) {
                  final _cubit = context.read<PaymentInvoiceCubit>();
                  return state.when(
                      onInitial: () =>
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                    Icons.shopping_bag_outlined, size: 80.0,
                                    color: const Color(0xFFBDBDBD)),
                                AppSpacing.height_16,
                                const Text(
                                  'لا توجد طلبات للتوصيل',
                                  style: TextStyle(
                                      fontSize: 18.0, color: AppColors.grey),
                                ),
                                AppSpacing.height_8,
                                const Text(
                                  'يمكنك تصفح المطاعم وإضافة طلبات جديدة',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Color(0xFF757575)),
                                ),
                              ],
                            ),
                          ),
                      onLoading: () => LoadingStateWidget(),
                      onLoaded: (shoppingList, userInfoModel) =>
                          PaymentInvoiceLayout(isPaid: isPaid,
                              shoppingList: shoppingList!,
                              userInfoModel: userInfoModel),
                      onError: (error) =>
                          ErrorStateWidget(
                              error: error.message,
                              onRetry: () => _cubit.displayInvoice())
                  );
                }
            )
        )
    );
  }
}


