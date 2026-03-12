import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';

// Screens
import '../../../../auth/presentation/screens/sgin_in_screen.dart';
import '../../../../cuisines/presentation/screens/french_screen.dart';
import '../../../../cuisines/presentation/screens/syrian_screen.dart';
import '../../../../cuisines/presentation/screens/italian_screen.dart';
import '../../../../cuisines/presentation/screens/mexican_screen.dart';
import '../../../../cuisines/presentation/screens/turkish_screen.dart';
import '../../../../cuisines/presentation/screens/chinese_screen.dart';
import '../../../../cuisines/presentation/screens/japanese_screen.dart';
import '../../../../cuisines/presentation/screens/egyptian_screen.dart';


class HomeLayout extends StatefulWidget {
  final List<HomeDataModel> homeData;

  const HomeLayout({required this.homeData, Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {

  static const _zero = AppNumbers.zero;
  static const _white = AppColors.white;
  static const _black = AppColors.black;

  late Timer _rotationTimer;
  double _rotationAngle = _zero;
  final double _secondsToComplete = 8.0;

  late AnimationController _slideController;
  late Animation<double> _leftColumnAnimation;
  late Animation<double> _rightColumnAnimation;

  bool _showSlideAnimation = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _preloadImages();
    if (mounted) {
      setState(() {
        _showSlideAnimation = true;
      });
      _startRotationAnimation();
      _setupSlideAnimations();
    }
  }


  Future<void> _preloadImages() async {
    final List<Future<void>> imageFutures = [];

    for (var item in widget.homeData) {
      final image = NetworkImage(item.image);
      final completer = image.evict().then((_) {
        return precacheImage(image, context);
      });
      imageFutures.add(completer);
    }

    await Future.wait(imageFutures);
  }

  void _startRotationAnimation() {
    const _threeHundredSixty = 360.0;

    const framesPerSecond = 60;
    final anglePerFrame = _threeHundredSixty /
        (_secondsToComplete * framesPerSecond);

    _rotationTimer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ framesPerSecond),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _rotationAngle += anglePerFrame;
          if (_rotationAngle >= _threeHundredSixty) {
            _rotationAngle = _threeHundredSixty;
            timer.cancel();
          }
        });
      },
    );
  }

  void _setupSlideAnimations() {
    const _threeHundred = 300.0;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _leftColumnAnimation =
        Tween<double>(begin: _threeHundred, end: _zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOut,
          ),
        );

    _rightColumnAnimation =
        Tween<double>(begin: -_threeHundred, end: _zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOut,
          ),
        );

    _slideController.forward();
  }

  Future<void> _signOut() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove(AppKeys.uId);
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    } catch (e) {
      print('Error during sign-out: $e');
      // You might want to show a snackbar or dialog here
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء تسجيل الخروج: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToCuisineScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  void dispose() {
    _rotationTimer.cancel();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeScreen();
  }

  Widget _buildHomeScreen() {
    const _grey = Color(0xFF212121);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _grey,
        appBar: AppBar(
          elevation: _zero,
          backgroundColor: _grey,
          centerTitle: true,
          title: const Text(
            'اختر مطبخك',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _white,
            ),
          ),
          leading: IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: _white),
            tooltip: 'تسجيل الخروج',
          ),
        ),
        body: Padding(
          padding: AppPaddings.paddingAll_10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftColumn(),
              const SizedBox(width: 10),
              _buildRightColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              _showSlideAnimation ? _leftColumnAnimation.value : _zero, _zero),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCuisineCard(0, EgyptianScreen()),
              _buildCuisineCard(2, TurkishScreen()),
              _buildCuisineCard(4, ChineseScreen()),
              _buildCuisineCard(6, ItalianScreen()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRightColumn() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              _showSlideAnimation ? _rightColumnAnimation.value : _zero, _zero),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCuisineCard(1, SyrianScreen()),
              _buildCuisineCard(3, MexicanScreen()),
              _buildCuisineCard(5, JapaneseScreen()),
              _buildCuisineCard(7, FrenchScreen()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCuisineCard(int index, Widget screen) {
    if (index >= widget.homeData.length) {
      return const SizedBox(); // Handle out of bounds
    }

    const _spacing = 155.0;
    final _cuisine = widget.homeData[index];
    const _borderRadius = BorderRadius.all(Radius.circular(16));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _navigateToCuisineScreen(screen),
        borderRadius: _borderRadius,
        child: Container(
          width: _spacing,
          height: _spacing,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            boxShadow: [
              BoxShadow(
                color: _black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: _borderRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildCuisineImage(_cuisine.image),
                _buildCuisineOverlay(),
                _buildCuisineTitle(_cuisine.title),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCuisineImage(String imageUrl) {
    return Hero(
      tag: imageUrl,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              color: _white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Color(0xFF424242),
            child: const Icon(
              Icons.broken_image,
              color: _white,
              size: 50,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCuisineOverlay() {
    const transparent = AppColors.transparent;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            transparent,
            transparent,
            _black.withOpacity(0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildCuisineTitle(String title) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _white,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: _black,
                offset: Offset(2, 2),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}


