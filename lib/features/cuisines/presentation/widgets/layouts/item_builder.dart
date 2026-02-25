import 'package:flutter/material.dart';
import '../../../data/models/data_model.dart';
import '../../../../cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/features/cart/presentation/screens/cart_data_screen.dart';


final List<String> mealSizes = ['صغير', 'وسط', 'كبير'];
final List<String> items = List.generate(10, (index) => (index + 1).toString());
final List<Color> mealColors = [Colors.amber, Colors.orange, Colors.red];


class ItemBuilder extends StatefulWidget {
  final DataModel _dataModel;
  final Function(int) _updateRating;

  ItemBuilder({
    required DataModel dataModel,
    required dynamic Function(int) updateRating,
    Key? key,
  })
      : _updateRating = updateRating,
        _dataModel = dataModel,
        super(key: key);

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
    _userRating = widget._dataModel.rating!.toDouble();

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
      //CartCubit.get(context).loadCartFromPrefs();
    });
    super.dispose();
  }

  Future<void> _preloadImage() async {
    try {
      await precacheImage(NetworkImage(widget._dataModel.orderImage!), context);
      if (mounted) {
        setState(() => _isImageLoaded = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImageLoaded = true);
      }
    }
  }

  void displayResult() {
    if (widget._dataModel.getSelectedItem <= 0) {
      buildSnackBar('الكمية يجب أن تكون أكبر من الصفر', Colors.red);
      return;
    }
    buildSnackBar('تمت الإضافة إلى السلة بنجاح', Colors.green[800]!);
  }

  num _getSizePrice() {
    switch (_currentSizeIndex) {
      case 0:
        return widget._dataModel.orderPrice! * 0.8;
      case 1:
        return widget._dataModel.orderPrice!;
      case 2:
        return widget._dataModel.orderPrice! * 1.2;
      default:
        return widget._dataModel.orderPrice!;
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
                    _currentSizeIndex =
                        (_currentSizeIndex + 1) % mealSizes.length;
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
                    widget._dataModel.orderImage!,
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
                      widget._dataModel.orderName!,
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
                              widget._dataModel.rating = _userRating.toInt();
                              widget._updateRating(_userRating.toInt());
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
                    value: widget._dataModel.selectedItem.toString(),
                    items: items.map((item) =>
                        DropdownMenuItem<String>(
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
                          widget._dataModel.selectedItem = int.parse(item);
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
                    onPressed: () =>
                        CartDataCubit.get(context).addOrder(
                          dataModel: widget._dataModel,
                          orderSize: mealSizes[_currentSizeIndex],
                        ).whenComplete(() => displayResult()),
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
                      CartDataCubit.get(context).addOrder(
                        dataModel: widget._dataModel,
                        orderSize: mealSizes[_currentSizeIndex],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartDataScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag),
                        Text(
                          '${_getSizePrice() *
                              widget._dataModel.selectedItem} ج',
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







