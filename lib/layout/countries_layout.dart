import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:international_cuisine/shared/cubit/cubit.dart';
import '../modles/data_model.dart';
import '../modules/update/update_screen.dart';
import 'cart_layout.dart';

final List<String> items = List.generate(10, (index) => (index + 1).toString());

final List<String> mealSizes = ['صغير', 'وسط', 'كبير'];
final List<Color> mealColors = [Colors.amber, Colors.orange, Colors.red];

class ItemBuilder extends StatefulWidget {
  final DataModel dataModel;

  const ItemBuilder({
    required this.dataModel,
    Key? key,
  }) : super(key: key);

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;
  late PageController _sizeController;
  bool _isImageLoaded = false;
  int _currentSizeIndex = 0;
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    _preloadImage();
    _sizeController = PageController();
    _userRating = widget.dataModel.rating!.toDouble();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: mealColors[0],
      end: mealColors[1],
    ).animate(_animationController);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sizeController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CartCubit.get(context).loadCartFromPrefs();
    });
    super.dispose();
  }

  Future<void> _preloadImage() async {
    try {
      await precacheImage(NetworkImage(widget.dataModel.orderImage!), context);
      if (mounted) {
        setState(() => _isImageLoaded = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImageLoaded = true);
      }
    }
  }

  num _getSizePrice() {
    switch (_currentSizeIndex) {
      case 0:
        return widget.dataModel.orderPrice! * 0.8;
      case 1:
        return widget.dataModel.orderPrice!;
      case 2:
        return widget.dataModel.orderPrice! * 1.2;
      default:
        return widget.dataModel.orderPrice!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isImageLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentSizeIndex = (_currentSizeIndex + 1) % mealSizes.length;
                    _sizeController.animateToPage(
                      _currentSizeIndex,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                    );

                    _colorAnimation = ColorTween(
                      begin: _colorAnimation.value,
                      end: mealColors[_currentSizeIndex],
                    ).animate(_animationController);

                    _animationController
                      ..reset()
                      ..forward();
                  });
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)),
                  child: Image.network(
                    widget.dataModel.orderImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, size: 50),
                        ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _colorAnimation.value,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 60,
                          height: 24,
                          child: PageView.builder(
                            controller: _sizeController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: mealSizes.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Text(
                                  mealSizes[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.dataModel.orderName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _userRating = (index + 1).toDouble();
                              widget.dataModel.rating = _userRating.toInt();
                              // هنا يمكنك إضافة كود لحفظ التقييم في قاعدة البيانات
                            });
                          },
                          child: Icon(
                            index < _userRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: 200,
                    borderRadius: BorderRadius.circular(12),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    value: widget.dataModel.selectItem.toString(),
                    items: items.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )).toList(),
                    onChanged: (item) {
                      if (item != null) {
                        setState(() {
                          widget.dataModel.selectItem = int.parse(item);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 70,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.grey[300],
                    onPressed: () => CartCubit.get(context).addItem(
                        dataModel: widget.dataModel,
                        orderSize: mealSizes[_currentSizeIndex],
                        context: context
                    ),
                    child: Icon(
                      Icons.add_shopping_cart,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MaterialButton(
                    height: 38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.amber,
                    onPressed: () {
                      CartCubit.get(context).addItem(
                          dataModel: widget.dataModel,
                          orderSize: mealSizes[_currentSizeIndex],
                          context: context
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag),
                        Text(
                          '${_getSizePrice() * widget.dataModel.selectItem} ج',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchableListBuilder extends StatefulWidget {
  final List<DataModel> dataModel;
  final List<DataModel> searchData;
  final String title;
  final BuildContext context;
  final bool isLoadingMore;
  final VoidCallback onPressed;
  final VoidCallback clearData;
  final void Function(String) getData;

  const SearchableListBuilder({
    required this.dataModel,
    required this.searchData,
    required this.title,
    required this.context,
    required this.onPressed,
    required this.isLoadingMore,
    required this.getData,
    required this.clearData,
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
        !widget.isLoadingMore) {
      widget.onPressed();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_onScrollData);
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    if(query.isNotEmpty) {
      widget.getData(query);
    }
    else{
      widget.clearData();
    }
    setState(() {
      _filteredData = widget.searchData.isEmpty
          ? widget.dataModel
          : widget.searchData.where((item) =>
          item.orderName!.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataModel.isNotEmpty && _searchController.text.isEmpty) {
      _filteredData = widget.dataModel;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: appBar(title: widget.title, context: widget.context),
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
                      itemCount: _filteredData.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _filteredData.length) {
                          return ItemBuilder(
                            dataModel: _filteredData[index],
                          );
                        } else {
                          return Center(
                            child: ! widget.isLoadingMore
                                ? const CircularProgressIndicator()
                                : const SizedBox(),
                          );
                        }
                      }
                    ),
                fallback: (context) =>
                    Center(
                      child: _searchController.text.isEmpty ?
                      CircularProgressIndicator(color: Colors.white,) :
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
                MaterialPageRoute(builder: (context) => CartScreen()),
              ),
          child: const Icon(Icons.shopping_cart, color: Colors.black),
        ),
      ),
    );
  }
}

PreferredSizeWidget appBar({
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
        IconButton(
          icon: const Icon(Icons.account_circle, size: 40, color: Colors.white),
          onPressed: () =>
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UpdateAccount())),
        ),
      ],
      title: Text(
        title,
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );


