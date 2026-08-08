import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class TurkishDataCubit extends BaseCuisineCubit {
  TurkishDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static TurkishDataCubit get(BuildContext context) =>
      BlocProvider.of<TurkishDataCubit>(context);

  @override
  String get cuisineName => 'turkish';
}


