import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
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

  //values
  static const _startPoint = 300.0;
  static const _endPoint = AppValues.none;
  static const _fullAngle = 360.0;

  //spaces
  static const _spacing155 = 155.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(16));

  late Timer _rotationTimer;
  double _rotationAngle = _endPoint;
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
    final anglePerFrame = _fullAngle /
        (_secondsToComplete * 60);

    _rotationTimer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ 60),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _rotationAngle += anglePerFrame;
          if (_rotationAngle >= _fullAngle) {
            _rotationAngle = _fullAngle;
            timer.cancel();
          }
        });
      },
    );
  }

  void _setupSlideAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _leftColumnAnimation =
        Tween<double>(begin: _startPoint, end: _endPoint).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Curves.easeOut,
          ),
        );

    _rightColumnAnimation =
        Tween<double>(begin: -_startPoint, end: _endPoint).animate(
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.grey,
        appBar: AppBar(
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
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: AppColors.white),
            tooltip: 'تسجيل الخروج',
          ),
        ),
        body: Padding(
          padding: AppPaddings.all_vSmall,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftColumn(),
              const SizedBox(width: 10.0),
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
              _showSlideAnimation ? _leftColumnAnimation.value : _endPoint,
              _endPoint),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCuisineCard(index: 0, screen: EgyptianScreen()),
              _buildCuisineCard(index: 2, screen: TurkishScreen()),
              _buildCuisineCard(index: 4, screen: ChineseScreen()),
              _buildCuisineCard(index: 6, screen: ItalianScreen()),
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
              _showSlideAnimation ? _rightColumnAnimation.value : _endPoint,
              _endPoint),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCuisineCard(index: 1, screen: SyrianScreen()),
              _buildCuisineCard(index: 3, screen: MexicanScreen()),
              _buildCuisineCard(index: 5, screen: JapaneseScreen()),
              _buildCuisineCard(index: 7, screen: FrenchScreen()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCuisineCard({
    required int index,
    required Widget screen
  }) {
    if (index >= widget.homeData.length) {
      return const SizedBox(); // Handle out of bounds
    }

    final _cuisine = widget.homeData[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _navigateToCuisineScreen(screen),
        borderRadius: _borderRadius,
        child: Container(
          width: _spacing155,
          height: _spacing155,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.3),
                blurRadius: 8.0,
                offset: const Offset(AppValues.none, 4.0),
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
              color: AppColors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Color(0xFF424242),
            child: const Icon(
              Icons.broken_image,
              color: AppColors.white,
              size: 50.0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCuisineOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.transparent,
            AppColors.transparent,
            AppColors.black.withOpacity(0.8),
          ],
          stops: const [AppValues.none, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildCuisineTitle(String title) {
    return Positioned(
      left: AppValues.none,
      right: AppValues.none,
      bottom: 12.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: AppColors.white,
            shadows: [
              Shadow(
                blurRadius: 6.0,
                color: AppColors.black,
                offset: Offset(2.0, 2.0),
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


