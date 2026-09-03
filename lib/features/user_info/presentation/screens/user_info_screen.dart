import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/appbar_widget.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../../../core/di/service _locator.dart';
import '../widgets/layouts/user_info_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/states/user_info_state.dart';
import '../cubits/user_info_cubit.dart';
import 'package:flutter/material.dart';


class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  static const _userInfo = 'معلومات المستخدم';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
        sl<UserInfoCubit>()
          ..getInfo(),
        child: BlocBuilder<UserInfoCubit, UserInfoState>(
            builder: (context, state) {
              final cubit = UserInfoCubit.get(context);
              return state.when(
                  onInitial: () =>
                  const InitialStateWidget(
                      _userInfo, Icons.info),
                  onLoading: () =>
                  const LoadingStateWidget(),
                  onLoaded: (data) {
                    return UserInfoLayout(
                      userModel: data.userModel,
                      messageResult: data.messageResult,
                      onUpdate: (userModel) =>
                          cubit.updateInfo(
                            firstName: userModel.firstName,
                            lastName: userModel.lastName,
                            userPhone: userModel.userPhone,
                            userLocation: userModel.userLocation,
                          ),
                    );
                  },
                  onError: (error) =>
                      error.buildErrorWidget(
                          onRetry: () => cubit.getInfo(),
                          appBar: AppbarWidget.build(context)
                      )
              );
            }
        )
    );
  }
}