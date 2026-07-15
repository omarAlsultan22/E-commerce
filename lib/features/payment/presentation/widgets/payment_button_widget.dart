import 'package:flutter/material.dart';
import '../../constants/payment_strings.dart';
import '../../constants/payment_constants.dart';
import '../../constants/payment_dimensions.dart';
import '../../constants/payment_text_styles.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';


class PaymentButtonWidget extends StatelessWidget {
  final bool isLoading;
  final int selectedMethod;
  final VoidCallback onPressed;

  const PaymentButtonWidget({
    super.key,
    required this.isLoading,
    required this.selectedMethod,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: PaymentDimensions.buttonPadding,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: AppColors.white)
          : Text(
        selectedMethod == PaymentConstants.paymentMethodFawry
            ? PaymentStrings.createFawryInvoice
            : PaymentStrings.completePayment,
        style: PaymentTextStyles.buttonText,
      ),
    );
  }
}