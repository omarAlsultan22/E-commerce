import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';


class PaymentTextStyles {

  static const TextStyle securityText = TextStyle(
    color: AppColors.grey,
    fontSize: 12.0,
  );

  static const TextStyle titleBold = TextStyle(
    fontSize: AppSizes.fontSize18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: AppSizes.fontSize18,
    color: AppColors.white,
  );

  static const TextStyle amountStyle = TextStyle(
    fontSize: 24.0,
    color: AppColors.primaryAmber,
  );
}