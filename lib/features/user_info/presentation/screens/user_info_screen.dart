import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../widgets/layouts/user_info_layout.dart';
import '../../domain/useCases/user_info_useCase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../states/states/user_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_info_cubit.dart';
import 'package:flutter/material.dart';


class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _repository = FirebaseFirestore.instance;
    final _userInfoRepository = FirestoreUserInfoRepository(repository: _repository);
    final _userInfoUseCase = UserInfoUseCase(
        userInfoRepository: _userInfoRepository);
    return ConnectivityAwareService(
        child: BlocProvider(
            create: (context) =>
                UserInfoCubit(userInfoUseCase: _userInfoUseCase),
            child: BlocBuilder<UserInfoCubit, UserInfoState>(
                builder: (context, state) {
                  final cubit = UserInfoCubit.get(context);
                  return state.when(
                    onInitial: () =>
                    const InitialStateWidget(
                        AppKeys.userInfo, Icons.info),
                    onLoading: () =>
                    const LoadingStateWidget(),
                    onLoaded: () =>
                        UserInfoLayout(
                            firstName: state.firstName,
                            lastName: state.lastName,
                            userPhone: state.userPhone,
                            userLocation: state.userLocation!
                        ),
                    onError: (error) =>
                        ErrorStateWidget(error: error.message,
                            onRetry: () => cubit.getInfo()),
                  );
                }
            )
        )
    );
  }
}