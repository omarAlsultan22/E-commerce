import '../../../features/evaluation/data/repositories_impl/evaluation_repository_impl.dart';
import '../../../features/evaluation/domain/repositories/evaluation_repositories.dart';
import '../../../features/evaluation/presentation/cubits/evaluation_cubit.dart';
import '../../../features/evaluation/domain/use_cases/evaluation_use_case.dart';
import '../../domain/data_sources/remote/firestore_service.dart';
import '../../providers/connectivity_provider.dart';
import '../service _locator.dart';


class EvaluationDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton<EvaluationRepository>(() =>
        EvaluationRepositoryImpl(dataSource: sl<FirestoreService>()));

    // UseCase
    sl.registerLazySingleton<EvaluationUseCase>(() =>
        EvaluationUseCase(repository: sl<EvaluationRepository>()));

    // Cubit
    sl.registerFactory<EvaluationCubit>(() =>
        EvaluationCubit(
            useCase: sl<EvaluationUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}