import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'base/base_data_cubit.dart';


class MexicanDataCubit extends BaseCuisineCubit {
  MexicanDataCubit({
    required super.dataUseCases,
    required super.connectivityProvider
  });

  static MexicanDataCubit get(BuildContext context) =>
      BlocProvider.of<MexicanDataCubit>(context);

  @override
  String get cuisineName => 'mexican';
}