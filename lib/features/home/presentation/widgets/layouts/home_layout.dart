import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _HomeLayoutState extends State<HomeLayout>
    with TickerProviderStateMixin {
  late Timer _rotationTimer;
  double _rotationAngle = 0.0;
  final double _secondsToComplete = 8.0;

  late AnimationController _slideController;
  late Animation<double> _leftColumnAnimation;
  late Animation<double> _rightColumnAnimation;

  bool _isInitializing = true;
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
        _isInitializing = false;
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
    const framesPerSecond = 60;
    final anglePerFrame = 360.0 / (_secondsToComplete * framesPerSecond);

    _rotationTimer = Timer.periodic(
      const Duration(milliseconds: 1000 ~/ framesPerSecond),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _rotationAngle += anglePerFrame;
          if (_rotationAngle >= 360.0) {
            _rotationAngle = 360.0;
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

    _leftColumnAnimation = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );

    _rightColumnAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
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
      await sharedPreferences.remove('uId');
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
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: const Text(
            'اختر مطبخك',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'تسجيل الخروج',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
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
              _showSlideAnimation ? _leftColumnAnimation.value : 0.0, 0.0),
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
              _showSlideAnimation ? _rightColumnAnimation.value : 0.0, 0.0),
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

    final cuisine = widget.homeData[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _navigateToCuisineScreen(screen),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 155,
          height: 155,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildCuisineImage(cuisine.image),
                _buildCuisineOverlay(),
                _buildCuisineTitle(cuisine.title),
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
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[800],
            child: const Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 50,
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
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.8),
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
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.black,
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


