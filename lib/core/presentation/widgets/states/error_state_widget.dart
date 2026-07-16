import 'package:flutter/material.dart';


class ErrorStateWidget extends StatelessWidget {
  final String? error;
  final String buttonText;
  final VoidCallback? onRetry;
  final PreferredSizeWidget? appBar;

  const ErrorStateWidget({
    super.key,
    this.error,
    this.onRetry,
    this.appBar,
    this.buttonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: appBar,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text('Error: $error'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}