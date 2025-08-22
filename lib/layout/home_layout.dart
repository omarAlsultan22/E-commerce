import 'dart:async';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/sgin_in/sgin_in.dart';
import '../modles/home_model.dart';
import '../modules/chinese/chinese_screen.dart';
import '../modules/egyptian/egyptian_screen.dart';
import '../modules/french/french_screen.dart';
import '../modules/italian/italian_screen.dart';
import '../modules/japanese/japanese_screen.dart';
import '../modules/mexican/mexican_screen.dart';
import '../modules/syrian/syrian_screen.dart';
import '../modules/turkish/turkish_screen.dart';

class HomeBuilder extends StatefulWidget {
  final List<HomeModel> homeModel;

  const HomeBuilder({required this.homeModel, Key? key}) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> with TickerProviderStateMixin {
  late Timer timer;
  double fullAngle = 0.0;
  final double secondsToComplete = 8.0;

  late AnimationController controller;
  late Animation<double> animation1;
  late Animation<double> animation2;
  bool _areImagesLoaded = false;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _preloadImages().then((_) {
      if (mounted) {
        setState(() {
          _areImagesLoaded = true;
        });
        if (mounted) {
          setState(() {
            _showAnimation = true;
          });
          startRotationAnimation();
          setupSlideAnimations();
        }
      }
    });
  }

  Future<void> _preloadImages() async {
    final List<Future<void>> futures = [];
    for (var item in widget.homeModel) {
      final image = NetworkImage(item.image);
      futures.add(image.evict().then((_) => precacheImage(image, context)));
    }
    await Future.wait(futures);
  }

  void startRotationAnimation() {
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        fullAngle += 360.0 / (secondsToComplete * 1000 ~/ 60);
        if (fullAngle >= 360.0) {
          fullAngle = 360.0;
          timer.cancel();
        }
      });
    });
  }

  void setupSlideAnimations() {
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    animation1 = Tween(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    animation2 = Tween(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    if (_showAnimation) {
      animation1 = Tween(begin: 300.0, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );

      animation2 = Tween(begin: -300.0, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }

    controller.forward();
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_areImagesLoaded) {
      return Center(
        child: LoadingScreen()
      );
    }

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
            onPressed: () async {
              try {
                SharedPreferences sharedPreferences = await SharedPreferences
                    .getInstance();
                await sharedPreferences.remove('uId');
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              } catch (e) {
                print('Error during sign-out: $e');
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: _showAnimation ? Offset(animation1.value, 0.0) : Offset.zero,
                child: Column(
                  children: [
                    _buildModel(
                        widget.homeModel[0].image, widget.homeModel[0].title,
                        EgyptianScreen()),
                    _buildModel(
                        widget.homeModel[2].image, widget.homeModel[2].title,
                        TurkishScreen()),
                    _buildModel(
                        widget.homeModel[4].image, widget.homeModel[4].title,
                        ChineseScreen()),
                    _buildModel(
                        widget.homeModel[6].image, widget.homeModel[6].title,
                        ItalianScreen()),
                  ],
                ),
              ),
              Transform.translate(
                offset: _showAnimation ? Offset(animation2.value, 0.0) : Offset.zero,
                child: Column(
                  children: [
                    _buildModel(
                        widget.homeModel[1].image, widget.homeModel[1].title,
                        SyrianScreen()),
                    _buildModel(
                        widget.homeModel[3].image, widget.homeModel[3].title,
                        MexicanScreen()),
                    _buildModel(
                        widget.homeModel[5].image, widget.homeModel[5].title,
                        JapaneseScreen()),
                    _buildModel(
                        widget.homeModel[7].image, widget.homeModel[7].title,
                        FrenchScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModel(String image, String title, Widget link) {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => link),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: image,
                  child: Image.network(
                    image,
                    width: 155,
                    height: 155,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image,
                            color: Colors.white, size: 50),
                      );
                    },
                  ),
                ),
                Container(
                  width: 155,
                  height: 155,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListHomeBuilder extends StatelessWidget {
  final List<HomeModel> homeModel;
  const ListHomeBuilder({
    required this.homeModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: homeModel.isNotEmpty,
      builder: (context) => HomeBuilder(homeModel: homeModel),
      fallback: (context) => LoadingScreen()
    );
  }
}

Widget LoadingScreen(){
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image.network(
        'https://firebasestorage.googleapis.com/v0/b/internationalcuisine-31b41.appspot.com/o/images%2Flog.png?alt=media&token=7b096993-5aab-4d7f-ac4c-309a15140242',
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: SizedBox(
            width: 25.0,
            height: 25.0,
            child: const CircularProgressIndicator(color: Colors.white)),
      ),
    ],
  );
}


