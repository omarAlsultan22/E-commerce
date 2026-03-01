import 'package:international_cuisine/features/invoice/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/features/invoice/presentation/widgets/layouts/payment_invoice_layout.dart';
import 'package:international_cuisine/features/invoice/domain/useCases/payment_Invoice_useCase.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../../../core/presentation/widgets/states/loading_state_widget.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
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

  //texts
  static const title = 'تم ارسال طلبك بنجاح!';
  static const text = 'قم بأخذ لقطة شاشة للفتورة';
  static const confirmBtnText = 'حسنا';

  static const noOrders = 'لا توجد طلبات للتوصيل';
  static const checkCuisines = 'يمكنك تصفح المطاعم وإضافة طلبات جديدة';

  //numbers
  static const eight = 8.0;
  static const fourteen = 14.0;
  static const sixteen = 16.0;
  static const eighteen = 18.0;
  static const eighty = 80.0;

  @override
  Widget build(BuildContext context) {
    final _cartCubit = context.read<CartDataCubit>();
    final _repository = FirebaseFirestore.instance;
    final _userInfoRepository = FirestoreInfoRepository(
        repository: _repository);
    final _useCase = PaymentInvoiceUseCase(
        userInfoRepository: _userInfoRepository);
    return ConnectivityAwareService(
        child: BlocProvider(create: (context) =>
        PaymentInvoiceCubit(cubit: _cartCubit, useCase: _useCase)
          ..displayInvoice(),
            child: BlocConsumer<PaymentInvoiceCubit, PaymentInvoiceState>(
                listener: (context, state) {
                  if (!state.isLoading && state.listIsNotEmpty) {
                    QuickAlert.show(
                      context: context,
                      title: title,
                      text: text,
                      type: QuickAlertType.success,
                      showConfirmBtn: true,
                      confirmBtnText: confirmBtnText,
                    );
                  }
                },
                builder: (context, state) {
                  final _cubit = context.read<PaymentInvoiceCubit>();
                  return state.when(
                      onInitial: () =>
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: eighty,
                                    color: Colors.grey[400]),
                                const SizedBox(height: sixteen),
                                const Text(
                                  noOrders,
                                  style: TextStyle(
                                      fontSize: eighteen, color: Colors.grey),
                                ),
                                const SizedBox(height: eight),
                                Text(
                                  checkCuisines,
                                  style: TextStyle(
                                      fontSize: fourteen, color: Colors
                                      .grey[600]),
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


