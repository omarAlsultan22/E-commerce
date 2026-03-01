import 'package:international_cuisine/features/user_info/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../widgets/layouts/update_account_layout.dart';
import '../../domain/useCases/user_info_useCase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../states/states/update_user_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/update_user_Info_cubit.dart';
import 'package:flutter/material.dart';


class UpdateAccountScreen extends StatelessWidget {
  const UpdateAccountScreen({super.key});

  static const String userInfo = 'userInfo';
  static const IconData infoIcon = Icons.info;

  @override
  Widget build(BuildContext context) {
    final repository = FirebaseFirestore.instance;
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final userInfoUseCase = UserInfoUseCase(
        userInfoRepository: userInfoRepository);
    return ConnectivityAwareService(
        child: BlocProvider(
            create: (context) =>
                UpdateUserInfoCubit(userInfoUseCase: userInfoUseCase),
            child: BlocBuilder<UpdateUserInfoCubit, UpdateUserInfoState>(
                builder: (context, state) {
                  final cubit = UpdateUserInfoCubit.get(context);
                  return state.when(
                    onInitial: () =>
                    const InitialStateWidget(
                        userInfo, infoIcon),
                    onLoading: () =>
                    const LoadingStateWidget(),
                    onLoaded: () =>
                        UpdateAccountLayout(
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