import 'package:flutter/material.dart';


class ErrorStateWidget extends StatelessWidget {
  final String error;
  final String? buttonText;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.buttonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
              child: Text(buttonText!),
            ),
          ],
        ),
    );
  }
}