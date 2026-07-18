import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/navigation/navigation_keys.dart';
import 'package:international_cuisine/core/services/app_lifecycle_service.dart';
import '../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/home/presentation/screens/home_screen.dart';

//cubits
import '../features/home/presentation/cubits/home_data_cubit.dart';
import '../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../features/cuisines/presentation/cubits/french_data_cubit.dart';
import '../features/cuisines/presentation/cubits/syrian_data_cubit.dart';
import '../features/cuisines/presentation/cubits/italian_data_cubit.dart';
import '../features/cuisines/presentation/cubits/mexican_data_cubit.dart';
import '../features/cuisines/presentation/cubits/turkish_data_cubit.dart';
import '../features/cuisines/presentation/cubits/chinese_data_cubit.dart';
import '../features/cuisines/presentation/cubits/japanese_data_cubit.dart';
import '../features/cuisines/presentation/cubits/egyptian_data_cubit.dart';

//dataSources
import '../core/data/data_sources/remote/firestore.dart';
import 'package:international_cuisine/core/data/data_sources/local/hive.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firebase_auth.dart';
import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';

//useCases
import '../features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import 'package:international_cuisine/features/auth/domain/useCases/sign_out_useCase.dart';
import 'package:international_cuisine/features/home/domain/useCases/home_data_useCase.dart';
import 'package:international_cuisine/features/cart/domain/useCases/cart_data_useCase.dart';

//repositories
import 'package:international_cuisine/features/auth/data/repositories_impl/firebase_auth_repository.dart';
import 'package:international_cuisine/features/cart/data/repositories_impl/hive_shopping_List_repository.dart';
import 'package:international_cuisine/features/home/data/repositories_impl/firestore_home_data_repository.dart';
import 'package:international_cuisine/features/cuisines/data/repositories_impl/firestore_cuisine_data_repository.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleService _lifecycleService;

  @override
  void initState() {
    super.initState();
    _lifecycleService = AppLifecycleService();
  }

  @override
  void dispose() {
    _lifecycleService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _cacheHelper = CacheHelper();

    //home useCase
    final _homeRepository = FirestoreService();
    final _userInfoRepository = FirestoreHomeDataRepository(
        repository: _homeRepository);
    final _homeDataUseCase = HomeDataUseCase(
        userInfoRepository: _userInfoRepository);
    final _authService = FirebaseAuthService();
    final _authRepository = FirebaseAuthRepository(authService: _authService);
    final _signOutUseCase = SignOutUseCase(
        cacheHelper: _cacheHelper, authRepository: _authRepository);

    //cuisine useCase
    final cuisineRepository = FirestoreService();
    final _repository = FirestoreCuisineDataRepository(
        firestore: cuisineRepository);
    final _dataUseCases = CuisineDataUseCase(repository: _repository);
    final _connectivityProvider = ConnectivityProvider();

    //cart useCase
    final _hiveStore = HiveStore(cacheHelper: _cacheHelper);
    final _hiveRepository = HiveShoppingListRepository(hiveStore: _hiveStore);
    final _cartUseCase = CartDataUseCase(
        repository: _hiveRepository, cacheHelper: _cacheHelper);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
          //connections
          BlocProvider<HomeDataCubit>(
              create: (context) =>
              HomeDataCubit(
                  signOutUseCase: _signOutUseCase,
                  homeDataUseCase: _homeDataUseCase,
                  connectivityProvider: _connectivityProvider
              )
                ..getData()
          ),
          BlocProvider<CartDataCubit>(
              create: (context) =>
              CartDataCubit(useCase: _cartUseCase)
                ..getCartData()
          ),
          BlocProvider(create: (context) =>
              ChineseDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              EgyptianDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              FrenchDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              ItalianDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              JapaneseDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              MexicanDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              SyrianDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
          BlocProvider(create: (context) =>
              TurkishDataCubit(dataUseCases: _dataUseCases,
                  connectivityProvider: _connectivityProvider)),
        ],
        child: MaterialApp(
            navigatorKey: NavigationKeys.navigatorKey,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen()
        )
    );
  }
}