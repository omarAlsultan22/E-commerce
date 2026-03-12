import 'package:flutter/material.dart';
import '../../../data/models/data_model.dart';
import '../../../../cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
import 'package:international_cuisine/features/cart/presentation/screens/cart_data_screen.dart';


final List<String> _mealSizes = ['صغير', 'وسط', 'كبير'];
final List<String> _items = List.generate(10, (index) => (index + 1).toString());
final List<Color> _mealColors = [CuisinesConstants.amber, Colors.orange, Colors.red];


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
      begin: _mealColors[0],
      end: _mealColors[1],
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
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
    if (widget._dataModel.getSelectedItem <= AppNumbers.zero) {
      buildSnackBar('الكمية يجب أن تكون أكبر من الصفر', AppColors.errorRed);
      return;
    }
    buildSnackBar('تمت الإضافة إلى السلة بنجاح', AppColors.successGreen);
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

    //numbers
    const _ten = 10.0;
    const _towHundred = 200.0;

    //spacing
    const _sizedBox = SizedBox(width: 8.0);

    //borders
    const _borderRadiusTop = Radius.circular(15);
    const _borderRadiusALl = AppBorders.borderRadius_12;

    //colors
    const _grey300 = AppColors.lightGrey300;
    const _amber = CuisinesConstants.amber;
    const _white = AppColors.white;
    const _black = AppColors.black;

    return Card(
      elevation: 5,
      margin: AppPaddings.paddingAll_10,
      shape: RoundedRectangleBorder(
        borderRadius: CuisinesConstants.borderRadius,
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
                        (_currentSizeIndex + 1) % _mealSizes.length;
                    _sizeController.animateToPage(
                      _currentSizeIndex,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                    );

                    _colorAnimation = ColorTween(
                      begin: _colorAnimation.value,
                      end: _mealColors[_currentSizeIndex],
                    ).animate(_animationController);

                    _animationController
                      ..reset()
                      ..forward();
                  });
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: _borderRadiusTop),
                  child: Image.network(
                    widget._dataModel.orderImage!,
                    height: _towHundred,
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
                          height: _towHundred,
                          color: _grey300,
                          child: const Icon(Icons.error, size: 50),
                        ),
                  ),
                ),
              ),
              Positioned(
                top: _ten,
                right: _ten,
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
                              color: _black.withOpacity(0.3),
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
                            itemCount: _mealSizes.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Text(
                                  _mealSizes[index],
                                  style: const TextStyle(
                                    color: _white,
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
                  color: _black.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(
                      top: _borderRadiusTop),
                ),
                child: Column(
                  children: [
                    Text(
                      widget._dataModel.orderName!,
                      style: const TextStyle(
                        color: _white,
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
                            color: _amber,
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
                    borderRadius: _borderRadiusALl,
                    color: AppColors.lightGrey200,
                  ),
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: _towHundred,
                    borderRadius: _borderRadiusALl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    value: widget._dataModel.selectedItem.toString(),
                    items: _items.map((item) =>
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
                _sizedBox,
                Container(
                  width: 70,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: _borderRadiusALl,
                    ),
                    color: _grey300,
                    onPressed: () =>
                        CartDataCubit.get(context).addOrder(
                          dataModel: widget._dataModel,
                          orderSize: _mealSizes[_currentSizeIndex],
                        ).whenComplete(() => displayResult()),
                    child: Icon(
                      Icons.add_shopping_cart,
                      size: 24,
                      color: AppColors.black,
                    ),
                  ),
                ),
                _sizedBox,
                Expanded(
                  child: MaterialButton(
                    height: 38,
                    shape: RoundedRectangleBorder(
                      borderRadius: _borderRadiusALl,
                    ),
                    color: _amber,
                    onPressed: () {
                      CartDataCubit.get(context).addOrder(
                        dataModel: widget._dataModel,
                        orderSize: _mealSizes[_currentSizeIndex],
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







