import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push.dart';

import 'item_image_section.dart';
import 'item_action_buttons.dart';
import 'package:flutter/material.dart';
import '../../data/models/data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/features/cuisines/constants/cuisines_constants.dart';
import 'package:international_cuisine/features/cart/presentation/screens/cart_data_screen.dart';


final List<String> _mealSizes = ['صغير', 'وسط', 'كبير'];
final List<Color> _mealColors = [AppColors.primaryAmber, Colors.orange, Colors.red];

class ItemBuilder extends StatefulWidget {
  final DataModel _dataModel;
  final Function(int) _updateRating;

  const ItemBuilder({
    required DataModel dataModel,
    required dynamic Function(int) updateRating,
    Key? key,
  })  : _updateRating = updateRating,
        _dataModel = dataModel,
        super(key: key);

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> with TickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 300);
  static const _sizeChangeDuration = Duration(milliseconds: 100);

  late PageController _sizeController;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  int _currentSizeIndex = 0;
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _userRating = widget._dataModel.rating!.toDouble();
  }

  void _initControllers() {
    _sizeController = PageController();
    _animationController = AnimationController(
      duration: _animationDuration,
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
  }

  void _onSizeChanged() {
    setState(() {
      _currentSizeIndex = (_currentSizeIndex + 1) % _mealSizes.length;
      _sizeController.animateToPage(
        _currentSizeIndex,
        duration: _sizeChangeDuration,
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
  }

  void _updateRating(double rating) {
    setState(() {
      _userRating = rating;
      widget._dataModel.rating = _userRating.toInt();
      widget._updateRating(_userRating.toInt());
    });
  }

  void _addToCartAndShowSnackBar() {
    if (widget._dataModel.getSelectedItem <= 0) {
      BuildSnackBar.show(
          context: context,
          message: 'الكمية يجب أن تكون أكبر من الصفر',
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    context.read<CartDataCubit>().addOrder(
      dataModel: widget._dataModel,
      orderSize: _mealSizes[_currentSizeIndex],
    ).whenComplete(() {
      BuildSnackBar.show(
          context: context,
          message: 'تمت الإضافة إلى السلة بنجاح',
          backgroundColor: AppColors.successGreen);
    });
  }

  void _addToCartAndNavigate() {
    context.read<CartDataCubit>().addOrder(
      dataModel: widget._dataModel,
      orderSize: _mealSizes[_currentSizeIndex],
    ).then((_) {
      BuildNavigatorPush.build(
          context: context,
          link: CartDataScreen()
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: AppPaddings.all_vSmall,
      shape: RoundedRectangleBorder(
        borderRadius: CuisinesConstants.borderRadius,
      ),
      child: Column(
        children: [
          ItemImageSection(
            dataModel: widget._dataModel,
            currentSizeIndex: _currentSizeIndex,
            sizeController: _sizeController,
            colorAnimation: _colorAnimation,
            scaleAnimation: _scaleAnimation,
            mealSizes: _mealSizes,
            mealColors: _mealColors,
            onSizeChanged: _onSizeChanged,
            userRating: _userRating,
            onRatingUpdate: _updateRating,
          ),
          ItemActionButtons(
            dataModel: widget._dataModel,
            currentSizeIndex: _currentSizeIndex,
            mealSizes: _mealSizes,
            onAddToCartAndShowSnackBar: _addToCartAndShowSnackBar,
            onAddToCartAndNavigate: _addToCartAndNavigate,
          ),
        ],
      ),
    );
  }
}