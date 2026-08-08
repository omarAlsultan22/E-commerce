import '../service _locator.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../../../features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import '../../../features/cuisines/presentation/cubits/french_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/syrian_data_cubit.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import '../../../features/cuisines/presentation/cubits/chinese_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/italian_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/mexican_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/turkish_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/japanese_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/egyptian_data_cubit.dart';
import '../../../features/cuisines/data/repositories_impl/firestore_cuisine_data_repository.dart';


class CuisineDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirestoreCuisineDataRepository(
            firestore: sl<FirestoreService>()));

    // UseCase
    sl.registerLazySingleton(() =>
        CuisineDataUseCase(repository: sl<FirestoreCuisineDataRepository>()));

    // Cubits
    sl.registerFactory(() =>
        ChineseDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        EgyptianDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        FrenchDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        ItalianDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        JapaneseDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        MexicanDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        SyrianDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory(() =>
        TurkishDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}