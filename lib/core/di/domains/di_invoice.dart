import '../../../features/invoice/data/repositories_impl/payment_invoice_repository_impl.dart';
import '../../../features/invoice/domain/repositories/payment_invoice_repository.dart';
import '../../../features/invoice/presentation/cubits/payment_invoice_cubit.dart';
import '../../../features/invoice/domain/use_cases/payment_Invoice_use_case.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../domain/data_sources/local/cache_helper.dart';
import '../../providers/connectivity_provider.dart';
import '../service _locator.dart';


class InvoiceDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<PaymentInvoiceRepository>(() =>
        PaymentInvoiceRepositoryImpl(
            sessionService: sl<SessionService>(),
            dataSource: sl<FirestoreService>(),
            cacheHelper: sl<CacheHelper>()));

    // UseCase
    sl.registerLazySingleton<PaymentInvoiceUseCase>(() =>
        PaymentInvoiceUseCase(
            userInfoRepository: sl<PaymentInvoiceRepository>()));

    // Cubit
    sl.registerFactory(() =>
        PaymentInvoiceCubit(
            useCase: sl<PaymentInvoiceUseCase>(),
            cartDataState: sl<CartDataCubit>().state,
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}