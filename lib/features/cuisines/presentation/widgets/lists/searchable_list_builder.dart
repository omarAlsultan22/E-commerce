import 'package:international_cuisine/features/evaluation/presentation/screens/evaluation_screen.dart';
import 'package:international_cuisine/features/cart/presentation/screens/cart_data_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../../../user_info/presentation/screens/update_account_screen.dart';
import '../../../data/models/data_model.dart';
import 'package:flutter/material.dart';
import '../layouts/item_builder.dart';


class SearchableListBuilder extends StatefulWidget {
  bool isLocked;
  final String title;
  final bool hasMore;
  final List<DataModel> dataList;
  final List<DataModel> searchData;
  final VoidCallback getMoreData;
  final VoidCallback clearData;
  final void Function(String) getSearchData;
  final void Function(int, int) updateRate;

  SearchableListBuilder({
    this.isLocked = false,
    required this.title,
    required this.getMoreData,
    required this.hasMore,
    required this.clearData,
    required this.updateRate,
    required this.dataList,
    required this.searchData,
    required this.getSearchData,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchableListBuilder> createState() => _SearchableListBuilderState();
}

class _SearchableListBuilderState extends State<SearchableListBuilder> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<DataModel> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
    _scrollController.addListener(_onScrollData);
  }

  void _onScrollData() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50.0 &&
        widget.hasMore && !widget.isLocked && _searchController.text.isEmpty) {
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
        _filteredData = widget.searchData.isEmpty
            ? widget.dataList
            : widget.searchData;
      });
    }
    else {
      widget.clearData();
      setState(() {
        _filteredData = widget.dataList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataList.isNotEmpty && _searchController.text.isEmpty) {
      _filteredData = widget.dataList;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _appBar(title: widget.title, context: context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن وجبة...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: ConditionalBuilder(
                condition: _filteredData.isNotEmpty,
                builder: (context) =>
                    ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(10),
                        itemCount: _filteredData.length +
                            (widget.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < _filteredData.length) {
                            return ItemBuilder(
                              dataModel: _filteredData[index],
                              updateRating: (rating) =>
                                  widget.updateRate(index, rating),

                            );
                          } else {
                            return Center(
                              child: widget.hasMore && _searchController.text
                                  .isEmpty
                                  ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const SizedBox(),
                            );
                          }
                        }
                    ),
                fallback: (context) =>
                    Center(
                      child: _searchController.text.isEmpty ?
                      CircularProgressIndicator(color: Colors.white) :
                      Text('لا توجد نتائج متاحة',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartDataScreen()),
              ),
          child: const Icon(Icons.shopping_cart, color: Colors.black),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar({
    required final String title,
    required final BuildContext context
  }) =>
      AppBar(
        elevation: 0,
        titleSpacing: -10,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (String value) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                    child: Text('التقييم'),
                    onTap: () => EvaluationScreen()
                ),
                PopupMenuItem<String>(
                  child: Text('الاعدادات'),
                  onTap: () =>
                      navigator(
                          context: context, link: const UpdateAccountScreen()),
                ),
              ];
            },
          )
        ],
        title: Text(
          title,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
}