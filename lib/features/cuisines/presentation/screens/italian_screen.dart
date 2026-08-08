import '../cubits/base/base_data_cubit.dart';
import '../cubits/italian_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class ItalianScreen extends BaseCuisineScreen {
  const ItalianScreen({super.key});

  @override
  String get title => 'المطبخ الايطالي';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      ItalianDataCubit.get(context);

  @override
  State<ItalianScreen> createState() => _ItalianScreenState();
}

class _ItalianScreenState extends BaseCuisineScreenState<ItalianScreen> {}

