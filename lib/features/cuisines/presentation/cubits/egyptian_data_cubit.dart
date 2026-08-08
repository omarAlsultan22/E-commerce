import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base/base_data_cubit.dart';


class EgyptianDataCubit extends BaseCuisineCubit {
  EgyptianDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static EgyptianDataCubit get(BuildContext context) =>
      BlocProvider.of<EgyptianDataCubit>(context);

  @override
  String get cuisineName => 'egyptian';
}

