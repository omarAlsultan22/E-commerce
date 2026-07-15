import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';


class InitialStateWidget extends StatelessWidget {
  final String _textType;
  final IconData _iconData;

  const InitialStateWidget(this._textType, this._iconData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            leading: BackButtonWidget(color: AppColors.grey, onPressed: () =>
                Navigator.pop(context)
            )
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _iconData,
                size: 100.0,
                color: AppColors.lightGrey300,
              ),
              Text(
                'لم يتم العثور على $_textType',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}