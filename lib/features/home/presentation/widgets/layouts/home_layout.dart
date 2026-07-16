import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/helpers/image_preloader.dart';
import '../../utils/helpers/cuisine_navigation_helper.dart';
import '../../utils/helpers/slide_animation_controller.dart';
import '../../utils/helpers/rotation_animation_controller.dart';
import '../../../../auth/presentation/screens/sgin_in_screen.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/data/models/message_result.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';
import 'package:international_cuisine/core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/features/home/presentation/widgets/cuisine_card_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push_replacement.dart';


class HomeLayout extends StatefulWidget {
  final VoidCallback signOut;
  final MessageResult messageResult;
  final List<HomeDataModel> homeData;

  const HomeLayout({
    super.key,
    required this.signOut,
    required this.homeData,
    required this.messageResult,
  });

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin ,  WidgetsBindingObserver{
  // Constants
  static const double _spacing = 155.0;
  static const BorderRadius _borderRadius = BorderRadius.all(
      Radius.circular(16));
  static const double _endPoint = AppValues.none;

  // Controllers
  late final SlideAnimationController _slideAnimation;
  late final RotationAnimationController _rotationAnimation;
  final ImagePreloader _imagePreloader = ImagePreloader();

  // State
  bool isPressed = false;
  bool _showSlideAnimation = false;
  double _rotationAngle = _endPoint;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeApp();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant HomeLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleMessageResult();
  }

  void _initializeControllers() {
    _slideAnimation = SlideAnimationController();
    _slideAnimation.initialize(this);
    _rotationAnimation = RotationAnimationController();
  }

  Future<void> _initializeApp() async {
    /*
    await _imagePreloader.preloadImages(
      context: context,
      homeData: widget.homeData,
    );
     */

    if (mounted) {
      setState(() {
        _showSlideAnimation = true;
      });

      _rotationAnimation.start(
        onAngleUpdate: (angle) {
          if (mounted) {
            setState(() => _rotationAngle = angle);
          }
        },
        onComplete: () {
          if (mounted) {
            _slideAnimation.forward();
          }
        },
        mounted: mounted,
      );
    }
  }

  void _handleMessageResult() {
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
      if (widget.messageResult.error == null) {
        BuildNavigatorPushReplacement.build(
          context: context,
          link: const SignInScreen(),
        );
      }
    }
  }

  void _showMessageResult(MessageResult messageResult) {
    BuildSnackBar.show(
      context: context,
      message: messageResult.message!,
      backgroundColor: messageResult.color!,
    );
  }

  @override
  void dispose() {
    _rotationAnimation.dispose();
    _slideAnimation.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      CartDataCubit.get(context).saveCartToHive();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.grey,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: AppValues.none,
      backgroundColor: AppColors.grey,
      centerTitle: true,
      title: const Text(
        'اختر مطبخك',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      leading: IconButton(
        onPressed: isPressed ? null : () {
          widget.signOut();
          isPressed = true;
        },
        icon: const Icon(Icons.logout, color: AppColors.white),
        tooltip: 'تسجيل الخروج',
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: AppPaddings.all_vSmall,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn(
            indices: CuisineNavigationHelper.getLeftColumnIndices(),
            animation: _slideAnimation.leftAnimation,
          ),
          const SizedBox(width: 10.0),
          _buildColumn(
            indices: CuisineNavigationHelper.getRightColumnIndices(),
            animation: _slideAnimation.rightAnimation,
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({
    required List<int> indices,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: _slideAnimation.controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _showSlideAnimation ? animation.value : _endPoint,
            _endPoint,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: indices.map((index) {
              return _buildCuisineCard(index);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCuisineCard(int index) {
    if (index >= widget.homeData.length) {
      return const SizedBox();
    }

    final cuisine = widget.homeData[index];

    return CuisineCardWidget(
      cuisine: cuisine,
      index: index,
      spacing: _spacing,
      borderRadius: _borderRadius,
      onTap: () => CuisineNavigationHelper.navigateToCuisine(context, index),
    );
  }
}