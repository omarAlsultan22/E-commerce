import '../cubits/base/base_data_cubit.dart';
import '../cubits/japanese_data_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_cuisine_screen.dart';


class JapaneseScreen extends BaseCuisineScreen {
  const JapaneseScreen({super.key});

  @override
  String get title => 'المطبخ الياباني';

  @override
  BaseCuisineCubit createCubit(BuildContext context) =>
      JapaneseDataCubit.get(context);

  @override
  State<JapaneseScreen> createState() => _JapaneseScreenState();
}

class _JapaneseScreenState extends BaseCuisineScreenState<JapaneseScreen> {}

