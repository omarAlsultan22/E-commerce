import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modules/chinese/cubit.dart';
import 'package:international_cuisine/modules/egyptian/cubit.dart';
import 'package:international_cuisine/modules/french/cubit.dart';
import 'package:international_cuisine/modules/home/cubit.dart';
import 'package:international_cuisine/modules/home/home_screen.dart';
import 'package:international_cuisine/modules/italian/cubit.dart';
import 'package:international_cuisine/modules/japanese/cubit.dart';
import 'package:international_cuisine/modules/mexican/cubit.dart';
import 'package:international_cuisine/modules/sgin_in/sgin_in.dart';
import 'package:international_cuisine/modules/syrian/cubit.dart';
import 'package:international_cuisine/modules/turkish/cubit.dart';
import 'package:international_cuisine/modules/update/cubit.dart';
import 'package:international_cuisine/shared/cubit/cubit.dart';
import 'package:international_cuisine/shared/local/shared_preferences.dart';
import 'shared/remot/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (context) =>
            HomeCubit()
              ..getData()),
            BlocProvider<CartCubit>(create: (context) => CartCubit()),
            BlocProvider<AppModelCubit>(create: (context) => AppModelCubit()),
            BlocProvider<EgyptianCubit>(create: (context) => EgyptianCubit()),
            BlocProvider<SyrianCubit>(create: (context) => SyrianCubit()),
            BlocProvider<TurkishCubit>(create: (context) => TurkishCubit()),
            BlocProvider<MexicanCubit>(create: (context) => MexicanCubit()),
            BlocProvider<ChineseCubit>(create: (context) => ChineseCubit()),
            BlocProvider<JapaneseCubit>(create: (context) => JapaneseCubit()),
            BlocProvider<ItalianCubit>(create: (context) => ItalianCubit()),
            BlocProvider<FrenchCubit>(create: (context) => FrenchCubit()),
          ],
          child: const MyApp(
          )
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen()
    );
  }
}




