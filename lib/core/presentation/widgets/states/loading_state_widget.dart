import 'package:flutter/material.dart';


class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          fit: BoxFit.fill,
          height: double.infinity,
          'assets/images/original_logo.png',
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}