import '../cubits/base/base_data_cubit.dart';
import '../cubits/mexican_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class MexicanScreen extends BaseCuisineScreen {
  const MexicanScreen({super.key});

  @override
  String get title => 'المطبخ المكسيكي';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      MexicanDataCubit.get(context);

  @override
  State<MexicanScreen> createState() => _MexicanScreenState();
}

class _MexicanScreenState extends BaseCuisineScreenState<MexicanScreen> {}

