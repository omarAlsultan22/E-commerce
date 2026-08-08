import '../cubits/base/base_data_cubit.dart';
import '../cubits/egyptian_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class EgyptianScreen extends BaseCuisineScreen {
  const EgyptianScreen({super.key});

  @override
  String get title => 'المطبخ المصري';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      EgyptianDataCubit.get(context);

  @override
  State<EgyptianScreen> createState() => _EgyptianScreenState();
}

class _EgyptianScreenState extends BaseCuisineScreenState<EgyptianScreen> {}

