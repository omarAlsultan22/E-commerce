import 'package:flutter/material.dart';
import '../../constants/payment_strings.dart';
import '../../constants/payment_dimensions.dart';
import '../../constants/payment_text_styles.dart';


class PaymentAmountWidget extends StatelessWidget {
  final double amount;

  const PaymentAmountWidget({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          PaymentStrings.totalAmount,
          style: PaymentTextStyles.titleBold,
          textAlign: TextAlign.center,
        ),
        PaymentDimensions.verticalSpacing10,
        Text(
          '${amount.toStringAsFixed(2)} جنيهاً',
          style: PaymentTextStyles.amountStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}