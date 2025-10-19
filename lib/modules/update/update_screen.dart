import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/constant.dart';
import '../../layout/update_layout.dart';
import 'package:flutter/material.dart';
import 'cubit.dart';


class UpdateAccountScreen extends StatelessWidget {
  const UpdateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppModelCubit()..getInfo(UserDetails.uId),
      child: const UpdateAccountLayout(),
    );
  }
}