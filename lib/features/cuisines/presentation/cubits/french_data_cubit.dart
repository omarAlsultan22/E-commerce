import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base/base_data_cubit.dart';


class FrenchDataCubit extends BaseCuisineCubit {
  FrenchDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static FrenchDataCubit get(BuildContext context) =>
      BlocProvider.of<FrenchDataCubit>(context);

  @override
  String get cuisineName => 'french';
}