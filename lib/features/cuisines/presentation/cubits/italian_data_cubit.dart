import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class ItalianDataCubit extends BaseCuisineCubit {
  ItalianDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static ItalianDataCubit get(BuildContext context) =>
      BlocProvider.of<ItalianDataCubit>(context);

  @override
  String get cuisineName => 'italian';
}