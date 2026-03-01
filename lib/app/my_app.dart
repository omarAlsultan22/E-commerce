import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:international_cuisine/core/data/data_sources/local/hive.dart';
import '../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/features/home/presentation/screens/home_screen.dart';

//cubits
import '../features/home/presentation/cubits/home_data_cubit.dart';
import '../features/cart/presentation/cubits/cart_data_cubit.dart';
import '../features/cuisines/domain/useCases/cuisine_data_useCase.dart';
import '../features/cuisines/presentation/cubits/french_data_cubit.dart';
import '../features/cuisines/presentation/cubits/syrian_data_cubit.dart';
import '../features/cuisines/presentation/cubits/italian_data_cubit.dart';
import '../features/cuisines/presentation/cubits/mexican_data_cubit.dart';
import '../features/cuisines/presentation/cubits/turkish_data_cubit.dart';
import '../features/cuisines/presentation/cubits/chinese_data_cubit.dart';
import '../features/cuisines/presentation/cubits/japanese_data_cubit.dart';
import '../features/cuisines/presentation/cubits/egyptian_data_cubit.dart';

//useCases
import 'package:international_cuisine/features/home/domain/useCases/home_data_useCase.dart';
import 'package:international_cuisine/features/cart/domain/useCases/cart_data_useCase.dart';

//repositories
import 'package:international_cuisine/features/cart/data/repositories_impl/hive_shopping_List_repository.dart';
import 'package:international_cuisine/features/home/data/repositories_impl/firestore_home_data_repository.dart';
import 'package:international_cuisine/features/cuisines/data/repositories_impl/firestore_cuisine_data_repository.dart';


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //home useCase
    final _firestoreRepository = FirebaseFirestore.instance;
    final _userInfoRepository = FirestoreHomeDataRepository(
        repository: _firestoreRepository);
    final _homeDataUseCase = HomeDataUseCase(
        userInfoRepository: _userInfoRepository);

    //cuisine useCase
    final _firestore = FirebaseFirestore.instance;
    final _repository = FirestoreCuisineDataRepository(firestore: _firestore);
    final _dataUseCases = CuisineDataUseCase(repository: _repository);

    //cart useCase
    final _hiveStore = HiveStore();
    final _hiveRepository = HiveShoppingListRepository(hiveStore: _hiveStore);
    final _cartUseCase = CartDataUseCase(repository: _hiveRepository);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
          //connections
          BlocProvider<HomeDataCubit>(
            create: (context) =>
            HomeDataCubit(homeDataUseCase: _homeDataUseCase)
              ..getData(),
          ),
          BlocProvider(create: (context) =>
              ChineseDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              EgyptianDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              FrenchDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              ItalianDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              JapaneseDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              MexicanDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              SyrianDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider(create: (context) =>
              TurkishDataCubit(dataUseCases: _dataUseCases)),
          BlocProvider<CartDataCubit>(
              create: (context) =>
              CartDataCubit(useCase: _cartUseCase)
                ..getCartData()
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const HomeScreen())
    );
  }
}