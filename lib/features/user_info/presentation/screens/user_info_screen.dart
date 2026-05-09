import 'package:international_cuisine/core/presentation/widgets/states/loading_state_widget.dart';
import 'package:international_cuisine/core/data/data_sources/local/shared_preferences.dart';
import '../../../../core/domain/services/connectivity_service/connectivity_provider.dart';
import 'package:international_cuisine/core/data/data_sources/remote/firestore.dart';
import '../../../../core/presentation/widgets/states/initial_state_widget.dart';
import '../../data/repositories_impl/firestore_user_info_repository.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../domain/useCases/user_info_useCase.dart';
import '../widgets/layouts/user_info_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/states/user_info_state.dart';
import '../cubits/user_info_cubit.dart';
import 'package:flutter/material.dart';


class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _repository = FirestoreService();
    final _cacheHelper = CacheHelper();
    final _userInfoRepository = FirestoreUserInfoRepository(
        repository: _repository, cacheHelper: _cacheHelper);
    final _userInfoUseCase = UserInfoUseCase(
        userInfoRepository: _userInfoRepository);
    final _connectivityProvider = ConnectivityProvider();
    return BlocProvider(
        create: (context) =>
            UserInfoCubit(
                userInfoUseCase: _userInfoUseCase,
                connectivityProvider: _connectivityProvider),
        child: BlocBuilder<UserInfoCubit, UserInfoState>(
            builder: (context, state) {
              final cubit = UserInfoCubit.get(context);
              return state.when(
                  onInitial: () =>
                  const InitialStateWidget(
                      AppKeys.userInfo, Icons.info),
                  onLoading: () =>
                  const LoadingStateWidget(),
                  onLoaded: (loadedState) =>
                      UserInfoLayout(
                        userModel: loadedState.firstModel,
                        messageResult: loadedState.secondModel,
                        onUpdate: (userModel) =>
                            cubit.updateInfo(
                              firstName: userModel.firstName,
                              lastName: userModel.lastName,
                              userPhone: userModel.userPhone,
                              userLocation: userModel.userLocation,
                            ),
                      ),
                  onError: (error) =>
                      error.buildErrorWidget(onRetry: () => cubit.getInfo())
              );
            }
        )
    );
  }
}