import 'package:flutter/material.dart';


class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imageUrl = 'assets/images/original_logo.png';

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: const SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}