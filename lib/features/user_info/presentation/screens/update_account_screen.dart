import 'package:international_cuisine/core/presentation/screens/internet_unavailability_screen.dart';
import 'package:international_cuisine/features/user_info/data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../widgets/layouts/update_account_layout.dart';
import '../../domain/useCases/user_info_useCase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../states/states/update_user_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/update_user_Info_cubit.dart';
import 'package:flutter/material.dart';


class UpdateAccountScreen extends StatelessWidget {
  const UpdateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FirebaseFirestore.instance;
    final userInfoRepository = FirestoreInfoRepository(repository: repository);
    final userInfoUseCase = UserInfoUseCase(
        userInfoRepository: userInfoRepository);
    return BlocProvider(
        create: (context) =>
            UpdateUserInfoCubit(userInfoUseCase: userInfoUseCase),
        child: BlocBuilder<UpdateUserInfoCubit, UpdateUserInfoState>(
            builder: (context, state) {
              final cubit = UpdateUserInfoCubit.get(context);
              return state.when(
                onInitial: () =>
                const InitialStateWidget('userInfo', Icons.info),
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
                error.isConnectionError
                    ? InternetUnavailabilityScreen(
                    onRetry: () => cubit.getInfo())
                    : ErrorStateWidget(error: error.message,
                    onRetry: () => cubit.getInfo()),
              );
            }
        )
    );
  }
}