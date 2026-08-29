import '../../../features/invoice/data/repositories_impl/firestore_payment_invoice_repository.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper.dart';
import '../../../features/invoice/presentation/cubits/payment_invoice_cubit.dart';
import '../../../features/invoice/domain/useCases/payment_Invoice_useCase.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class InvoiceDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirestorePaymentInvoiceRepository(
            repository: sl<FirestoreService>(),
            cacheHelper: sl<CacheHelper>()));

    // UseCase
    sl.registerLazySingleton(() =>
        PaymentInvoiceUseCase(
            userInfoRepository: sl<FirestorePaymentInvoiceRepository>()));

    // Cubit
    sl.registerFactory(() =>
        PaymentInvoiceCubit(
            useCase: sl<PaymentInvoiceUseCase>(),
            cartDataState: sl<CartDataCubit>().state,
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}