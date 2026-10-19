import '../../../features/evaluation/data/repositories_impl/evaluation_repository_impl.dart';
import '../../../features/evaluation/presentation/cubits/evaluation_cubit.dart';
import '../../../features/evaluation/domain/use_cases/evaluation_use_case.dart';
import '../../providers/connectivity_provider.dart';
import '../../data/data_sources/remote/firestore_service_impl.dart';
import '../service _locator.dart';


class EvaluationDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        EvaluationRepositoryImpl(dataSource: sl<FirestoreServiceImpl>()));

    // UseCase
    sl.registerLazySingleton(() =>
        EvaluationUseCase(repository: sl<EvaluationRepositoryImpl>()));

    // Cubit
    sl.registerFactory(() =>
        EvaluationCubit(
            useCase: sl<EvaluationUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}