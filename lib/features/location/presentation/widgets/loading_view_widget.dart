import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spaces.dart';


class LoadingViewWidget extends StatelessWidget {
  final String message;

  const LoadingViewWidget({
    super.key,
    this.message = "جاري تحميل الخريطة...",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          AppSpaces.verticalSpacing_16,
          Text(message),
        ],
      ),
    );
  }
}