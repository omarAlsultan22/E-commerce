import 'package:international_cuisine/features/evaluation/presentation/screens/evaluation_screen.dart';
import 'package:international_cuisine/features/cart/presentation/screens/cart_data_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../../../user_info/presentation/screens/user_info_screen.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../data/models/categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/data_model.dart';
import 'package:flutter/material.dart';
import '../item_builder.dart';


class SearchableListBuilder extends StatefulWidget {
  bool isLocked;
  final String title;
  final VoidCallback clearData;
  final VoidCallback getMoreData;
  final MessageResult messageResult;
  final CategoriesModel categoriesModel;
  final void Function(String) getSearchData;
  final void Function(int, int) updateRate;

  SearchableListBuilder({
    this.isLocked = false,
    required this.title,
    required this.clearData,
    required this.updateRate,
    required this.getMoreData,
    required this.getSearchData,
    required this.messageResult,
    required this.categoriesModel,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchableListBuilder> createState() => _SearchableListBuilderState();
}

class _SearchableListBuilderState extends State<SearchableListBuilder> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<DataModel> _filteredData = [];
  late final CartDataCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CartDataCubit>();
    _searchController.addListener(_performSearch);
    _scrollController.addListener(_onScrollData);
  }

  @override
  void didUpdateWidget(covariant SearchableListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
    }
    setState(() {});
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50.0 &&
        widget.categoriesModel.hasMore && !widget.isLocked &&
        _searchController.text.isEmpty) {
      widget.isLocked = true;
      widget.getMoreData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(_performSearch);
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      widget.getSearchData(query);
      setState(() {
        _filteredData = (widget.categoriesModel.searchDataIsEmpty
            ? widget.categoriesModel.categoryData
            : widget.categoriesModel.searchData)!;
      });
    }
    else {
      widget.clearData();
      setState(() {
        _filteredData = widget.categoriesModel.categoryData!;
      });
    }
  }

  void _showMessageResult(MessageResult messageResult) {
    BuildSnackBar.show(
        context: context,
        message: messageResult.message!,
        backgroundColor: messageResult.color!
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.categoriesModel.categoryDataIsEmpty &&
        _searchController.text.isEmpty) {
      _filteredData = widget.categoriesModel.categoryData!;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.darkGrey,
        appBar: _appBar(
            title: widget.title,
            context: context
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 5.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن وجبة...',
                  prefixIcon: Icon(Icons.search, color: AppColors.lightGrey400),
                  border: OutlineInputBorder(
                    borderRadius: CuisinesConstants.borderRadius,
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.mediumGrey800,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                ),
                style: TextStyle(color: AppColors.white),
              ),
            ),
            Expanded(
              child: ConditionalBuilder(
                condition: _filteredData.isNotEmpty,
                builder: (context) =>
                    ListView.builder(
                        controller: _scrollController,
                        padding: AppPaddings.all_vSmall,
                        itemCount: _filteredData.length +
                            (widget.categoriesModel.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _filteredData.length) {
                            return ItemBuilder(
                              dataModel: _filteredData[index],
                              updateRating: (rating) =>
                                  widget.updateRate(index, rating),
                              addOrder: ({
                                required dataModel,
                                required orderSize
                              }) =>
                                  _cubit.addOrder(
                                      dataModel: dataModel,
                                      orderSize: orderSize
                                  ),
                            );
                          } else {
                            return Center(
                              child: widget.categoriesModel.hasMore &&
                                  _searchController.text
                                      .isEmpty
                                  ? const CircularProgressIndicator(
                                  color: AppColors.white)
                                  : const SizedBox(),
                            );
                          }
                        }
                    ),
                fallback: (context) =>
                    Center(
                      child: _searchController.text.isEmpty ?
                      CircularProgressIndicator(color: AppColors.white) :
                      Text('لا توجد نتائج متاحة',
                          style: TextStyle(color: AppColors.white,
                              fontSize: AppSizes.fontSize18)),
                    ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryAmber,
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartDataScreen()),
              ),
          child: const Icon(Icons.shopping_cart, color: AppColors.black),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar({
    required final String title,
    required final BuildContext context
  }) {
    return AppBar(
      elevation: AppValues.none,
      titleSpacing: -10.0,
      scrolledUnderElevation: AppValues.none,
      backgroundColor: AppColors.darkGrey,
      leading: BackButtonWidget(
          color: AppColors.white, onPressed: () => Navigator.pop(context)),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: AppColors.white),
          onSelected: (String value) {},
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                  child: Center(child: const Text('التقييم')),
                  onTap: () =>
                      BuildNavigatorPush.build(
                          context: context, link: EvaluationScreen()
                      )
              ),
              PopupMenuItem<String>(
                child: Center(child: const Text('الحساب')),
                onTap: () =>
                    BuildNavigatorPush.build(
                        context: context, link: const UserInfoScreen()),
              ),
            ];
          },
        )
      ],
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: AppColors.white
        ),
      ),
    );
  }
}