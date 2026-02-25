import 'package:flutter/material.dart';
import '../../domain/services/connectivity_service/connectivity_service.dart';


class InternetUnavailabilityScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const InternetUnavailabilityScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
          ),

          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/images/original_logo.png',
              fit: BoxFit.contain,
            ),
          ),

          // محتوى الشاشة
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 80,
                  color: Colors.grey[600],
                ),

                const SizedBox(height: 20),

                // النصوص
                _buildText('OOPS!', 28.0),
                const SizedBox(height: 8),
                _buildText('NO INTERNET', 24.0),
                const SizedBox(height: 20),
                _buildText(
                  'Please check your network connection.',
                  16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700],
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async => _hasInternet(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _buildText('TRY AGAIN', 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _hasInternet() async {
    final hasInternet = await ConnectivityService.checkInternetConnection();
    if (hasInternet) {
      onRetry();
    }
  }

  Widget _buildText(String text,
      double fontSize, {
        FontWeight fontWeight = FontWeight.bold,
        Color? color,
      }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.grey[800],
      ),
    );
  }
}