import 'package:flutter/material.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';


class ImagePreloader {
  Future<void> preloadImages({
    required BuildContext context,
    required VoidCallback onComplete,
    required List<HomeDataModel> homeData,
  }) async {
    final List<Future<void>> imageFutures = [];

    for (var item in homeData) {
      final image = NetworkImage(item.image);
      final future = precacheImage(image, context);
      imageFutures.add(future);
    }

    await Future.wait(imageFutures).whenComplete(() => onComplete());
  }
}