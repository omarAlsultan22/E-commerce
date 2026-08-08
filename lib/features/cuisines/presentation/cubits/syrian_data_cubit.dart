import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class SyrianDataCubit extends BaseCuisineCubit {
  SyrianDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static SyrianDataCubit get(BuildContext context) =>
      BlocProvider.of<SyrianDataCubit>(context);

  @override
  String get cuisineName => 'syrian';
}


