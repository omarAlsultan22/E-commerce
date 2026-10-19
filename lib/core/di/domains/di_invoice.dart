import '../../../features/invoice/data/repositories_impl/payment_invoice_repository_impl.dart';
import 'package:international_cuisine/core/data/data_sources/local/cache_helper_impl.dart';
import '../../../features/invoice/presentation/cubits/payment_invoice_cubit.dart';
import '../../../features/invoice/domain/use_cases/payment_Invoice_use_case.dart';
import '../../providers/connectivity_provider.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import '../../../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../service _locator.dart';


class InvoiceDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        PaymentInvoiceRepositoryImpl(
            sessionService: sl<SessionService>(),
            dataSource: sl<FirestoreServiceImpl>(),
            cacheHelper: sl<CacheHelperImpl>()));

    // UseCase
    sl.registerLazySingleton(() =>
        PaymentInvoiceUseCase(
            userInfoRepository: sl<PaymentInvoiceRepositoryImpl>()));

    // Cubit
    sl.registerFactory(() =>
        PaymentInvoiceCubit(
            useCase: sl<PaymentInvoiceUseCase>(),
            cartDataState: sl<CartDataCubit>().state,
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}