import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/countries_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';

class MexicanScreen extends StatelessWidget {
  MexicanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MexicanCubit.get(context).getData();
    return BlocConsumer<MexicanCubit, CubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final mexicanCubit = MexicanCubit.get(context);
        final dataModelList = mexicanCubit.dataModelList;
        final isLoadingMore = mexicanCubit.isLoadingMore;
        return SearchableListBuilder(
            dataModel: dataModelList,
            context: context,
            title: 'المطبخ المكسيكي',
            onPressed: () => mexicanCubit.getData(),
            isLoadingMore: isLoadingMore);
      },
    );
  }
}