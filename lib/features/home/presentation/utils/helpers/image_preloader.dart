import 'package:flutter/material.dart';
import 'package:international_cuisine/features/home/data/models/home_model.dart';


class ImagePreloader {
  Future<void> preloadImages({
    required BuildContext context,
    required List<HomeDataModel> homeData,
  }) async {
    final List<Future<void>> imageFutures = [];

    for (var item in homeData) {
      final image = NetworkImage(item.image);
      final completer = image.evict().then((_) {
        return precacheImage(image, context);
      });
      imageFutures.add(completer);
    }

    await Future.wait(imageFutures);
  }
}