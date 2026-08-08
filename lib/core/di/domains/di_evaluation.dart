import '../../../features/evaluation/data/repositories_impl/firebase_evaluation_repository.dart';
import '../../../features/evaluation/presentation/cubits/evaluation_cubit.dart';
import '../../domain/services/connectivity_service/connectivity_provider.dart';
import '../../../features/evaluation/domain/useCases/evaluation_useCase.dart';
import '../../data/data_sources/remote/firestore.dart';
import '../service _locator.dart';


class EvaluationDependencies {
  static void register() {
    // Repository
    sl.registerLazySingleton(() =>
        FirebaseEvaluationRepository(firestore: sl<FirestoreService>()));

    // UseCase
    sl.registerLazySingleton(() =>
        EvaluationUseCase(repository: sl<FirebaseEvaluationRepository>()));

    // Cubit
    sl.registerFactory(() =>
        EvaluationCubit(
            useCase: sl<EvaluationUseCase>(),
            connectivityProvider: sl<ConnectivityProvider>()));
  }
}