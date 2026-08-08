import '../cubits/base/base_data_cubit.dart';
import '../cubits/syrian_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class SyrianScreen extends BaseCuisineScreen {
  const SyrianScreen({super.key});

  @override
  String get title => 'المطبخ السوري';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      SyrianDataCubit.get(context);

  @override
  State<SyrianScreen> createState() => _SyrianScreenState();
}

class _SyrianScreenState extends BaseCuisineScreenState<SyrianScreen> {}
