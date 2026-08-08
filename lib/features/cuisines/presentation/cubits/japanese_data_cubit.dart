import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class JapaneseDataCubit extends BaseCuisineCubit {
  JapaneseDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static JapaneseDataCubit get(BuildContext context) =>
      BlocProvider.of<JapaneseDataCubit>(context);

  @override
  String get cuisineName => 'japanese';
}