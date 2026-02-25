import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../invoice/presentation/screens/payment_invoice_screen.dart';
import 'package:international_cuisine/features/payment/presentation/screens/payment_screen.dart';
import 'package:international_cuisine/features/payment/presentation/widgets/layouts/payment_field_layout.dart';


class PaymentWaySelectionScreen extends StatelessWidget {
  const PaymentWaySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر طريق الدفع'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PaymentFieldLayout(iconName: 'الدفع الالكتروني',
              iconType: Icons.credit_card,
              onTap: () => navigator(link: PaymentScreen(), context: context)),
          PaymentFieldLayout(iconName: 'الدفع عند الاستلام',
              iconType: FontAwesomeIcons.handHoldingUsd,
              onTap: () =>
                  navigator(link: PaymentInvoiceScreen(isPaid: false),
                      context: context))
        ],
      ),
    );
  }
}
