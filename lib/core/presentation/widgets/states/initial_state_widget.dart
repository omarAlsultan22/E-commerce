import 'package:flutter/material.dart';


class InitialStateWidget extends StatelessWidget {
  final String _textType;
  final IconData _iconData;

  const InitialStateWidget(this._textType, this._iconData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconData,
              size: 100.0,
              color: Colors.grey[300],
            ),
            Text(
              'لم يتم العثور على $_textType',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}