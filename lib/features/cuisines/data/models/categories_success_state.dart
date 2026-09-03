import 'categories_model.dart';
import '../../../../core/data/models/message_result.dart';
import 'package:international_cuisine/core/presentation/states/base/main_loaded_state.dart';


class CategoriesSuccessState extends LoadedState {
  final MessageResult messageResult;
  final CategoriesModel categoriesModel;

  const CategoriesSuccessState({
    required this.messageResult,
    required this.categoriesModel
  });
}