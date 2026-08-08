import '../cubits/base/base_data_cubit.dart';
import '../cubits/turkish_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class TurkishScreen extends BaseCuisineScreen {
  const TurkishScreen({super.key});

  @override
  String get title => 'المطبخ التركي';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      TurkishDataCubit.get(context);

  @override
  State<TurkishScreen> createState() => _TurkishScreenState();
}

class _TurkishScreenState extends BaseCuisineScreenState<TurkishScreen> {}

