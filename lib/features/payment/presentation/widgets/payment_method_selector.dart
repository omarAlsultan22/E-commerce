import 'package:flutter/material.dart';
import '../../constants/payment_strings.dart';
import '../../constants/payment_constants.dart';
import '../../constants/payment_dimensions.dart';
import '../../constants/payment_text_styles.dart';


class PaymentMethodSelector extends StatelessWidget {
  final int selectedPaymentMethod;
  final ValueChanged<int> onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedPaymentMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            PaymentStrings.totalAmount, style: PaymentTextStyles.titleBold),
        PaymentDimensions.verticalSpacing10,
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text(PaymentStrings.creditCard),
                selected: selectedPaymentMethod ==
                    PaymentConstants.paymentMethodCard,
                onSelected: (_) =>
                    onMethodSelected(PaymentConstants.paymentMethodCard),
              ),
            ),
            PaymentDimensions.horizontalSpacing8,
            Expanded(
              child: ChoiceChip(
                label: const Text(PaymentStrings.fawry),
                selected: selectedPaymentMethod ==
                    PaymentConstants.paymentMethodFawry,
                onSelected: (_) =>
                    onMethodSelected(PaymentConstants.paymentMethodFawry),
              ),
            ),
            PaymentDimensions.horizontalSpacing8,
            Expanded(
              child: ChoiceChip(
                label: const Text(PaymentStrings.vodafoneCash),
                selected: selectedPaymentMethod ==
                    PaymentConstants.paymentMethodVodafone,
                onSelected: (_) =>
                    onMethodSelected(PaymentConstants.paymentMethodVodafone),
              ),
            ),
          ],
        ),
      ],
    );
  }
}