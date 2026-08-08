import '../cubits/base/base_data_cubit.dart';
import '../cubits/french_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class FrenchScreen extends BaseCuisineScreen {
  const FrenchScreen({super.key});

  @override
  String get title => 'المطبخ الفرنسي';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      FrenchDataCubit.get(context);

  @override
  State<FrenchScreen> createState() => _FrenchScreenState();
}

class _FrenchScreenState extends BaseCuisineScreenState<FrenchScreen> {}

