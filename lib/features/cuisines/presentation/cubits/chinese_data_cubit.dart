import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class ChineseDataCubit extends BaseCuisineCubit {
  ChineseDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static ChineseDataCubit get(BuildContext context) =>
      BlocProvider.of<ChineseDataCubit>(context);

  @override
  String get cuisineName => 'chinese';
}