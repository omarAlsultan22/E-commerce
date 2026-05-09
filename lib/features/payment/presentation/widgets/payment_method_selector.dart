import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../constants/payment_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/payment_constants.dart';


class PaymentMethodSelector extends StatelessWidget {
  final int selectedPaymentMethod;
  final Function(int) onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedPaymentMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(AppStrings.totalAmount, style: PaymentTextStyles.titleBold),
        AppDimensions.verticalSpacing10,
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text(AppStrings.creditCard),
                selected: selectedPaymentMethod ==
                    PaymentConstants.paymentMethodCard,
                onSelected: (_) =>
                    onMethodSelected(PaymentConstants.paymentMethodCard),
              ),
            ),
            AppDimensions.horizontalSpacing8,
            Expanded(
              child: ChoiceChip(
                label: const Text(AppStrings.fawry),
                selected: selectedPaymentMethod ==
                    PaymentConstants.paymentMethodFawry,
                onSelected: (_) =>
                    onMethodSelected(PaymentConstants.paymentMethodFawry),
              ),
            ),
            AppDimensions.horizontalSpacing8,
            Expanded(
              child: ChoiceChip(
                label: const Text(AppStrings.vodafoneCash),
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