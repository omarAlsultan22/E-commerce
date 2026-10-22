import '../service _locator.dart';
import '../../providers/connectivity_provider.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../../features/cuisines/presentation/cubits/french_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/syrian_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/chinese_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/italian_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/mexican_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/turkish_data_cubit.dart';
import '../../../features/cuisines/domain/use_cases/cuisine_data_use_case.dart';
import '../../../features/cuisines/presentation/cubits/japanese_data_cubit.dart';
import '../../../features/cuisines/presentation/cubits/egyptian_data_cubit.dart';
import '../../../features/cuisines/domain/repositories/cuisine_data_repository.dart';
import '../../../features/cuisines/data/repositories_impl/cuisine_data_repository_impl.dart';


class CuisineDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<CuisineDataRepository>(() =>
        CuisineDataRepositoryImpl(
            dataSource: sl<FirestoreService>()));

    // UseCase
    sl.registerLazySingleton<CuisineDataUseCase>(() =>
        CuisineDataUseCase(repository: sl<CuisineDataRepository>()));

    // Cubits
    sl.registerFactory<ChineseDataCubit>(() =>
        ChineseDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<EgyptianDataCubit>(() =>
        EgyptianDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<FrenchDataCubit>(() =>
        FrenchDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<ItalianDataCubit>(() =>
        ItalianDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<JapaneseDataCubit>(() =>
        JapaneseDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<MexicanDataCubit>(() =>
        MexicanDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<SyrianDataCubit>(() =>
        SyrianDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));

    sl.registerFactory<TurkishDataCubit>(() =>
        TurkishDataCubit(dataUseCases: sl<CuisineDataUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}