import 'package:flutter/material.dart';
import '../../constants/payment_strings.dart';
import '../../constants/payment_text_styles.dart';


class PaymentSecurityMessageWidget extends StatelessWidget {
  const PaymentSecurityMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      PaymentStrings.securityMessage,
      style: PaymentTextStyles.securityText,
      textAlign: TextAlign.center,
    );
  }
}