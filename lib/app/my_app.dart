import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/di/service _locator.dart';
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => sl<ConnectivityProvider>()),
          //connections
          BlocProvider<HomeDataCubit>(
              create: (context) =>
              sl<HomeDataCubit>()
                ..getData()
          ),
          BlocProvider<CartDataCubit>(
              create: (context) =>
              sl<CartDataCubit>()
                ..getCartData()
          ),
          BlocProvider(create: (context) =>
              sl<ChineseDataCubit>()),
          BlocProvider(create: (context) =>
              sl<EgyptianDataCubit>()),
          BlocProvider(create: (context) =>
              sl<FrenchDataCubit>()),
          BlocProvider(create: (context) =>
              sl<ItalianDataCubit>()),
          BlocProvider(create: (context) =>
              sl<JapaneseDataCubit>()),
          BlocProvider(create: (context) =>
              sl<MexicanDataCubit>()),
          BlocProvider(create: (context) =>
              sl<SyrianDataCubit>()),
          BlocProvider(create: (context) =>
              sl<TurkishDataCubit>()),
        ],
        child: MaterialApp(
            navigatorKey: NavigationKeys.navigatorKey,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen()
        )
    );
  }
}