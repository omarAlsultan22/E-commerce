import 'home_model.dart';
import '../../../../core/data/models/message_result.dart';
import 'package:international_cuisine/core/presentation/states/base/main_loaded_state.dart';


class HomeDataSuccessState extends LoadedState {
  final MessageResult messageResult;
  final List<HomeDataModel> homeData;

  const HomeDataSuccessState({
    required this.homeData,
    required this.messageResult,
  });
}