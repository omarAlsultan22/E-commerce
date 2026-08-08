import 'base/base_cuisine_screen.dart';
import '../cubits/chinese_data_cubit.dart';
import '../cubits/base/base_data_cubit.dart';
import 'package:flutter/src/widgets/framework.dart';


class ChineseScreen extends BaseCuisineScreen {
  const ChineseScreen({super.key});

  @override
  String get title => 'المطبخ الصيني';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      ChineseDataCubit.get(context);

  @override
  State<ChineseScreen> createState() => _ChineseScreenState();

}

class _ChineseScreenState extends BaseCuisineScreenState<ChineseScreen>{}
