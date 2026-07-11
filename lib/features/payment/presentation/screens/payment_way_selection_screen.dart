import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../invoice/presentation/screens/payment_invoice_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push.dart';
import 'package:international_cuisine/features/payment/presentation/screens/payment_screen.dart';
import 'package:international_cuisine/features/payment/presentation/widgets/layouts/payment_field_layout.dart';


class PaymentWaySelectionScreen extends StatelessWidget {
  const PaymentWaySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر طريق الدفع'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PaymentFieldLayout(iconName: 'الدفع الالكتروني',
              iconType: Icons.credit_card,
              onTap: () =>
                  BuildNavigatorPush.build(
                      link: PaymentScreen(), context: context)),
          PaymentFieldLayout(
              iconName: 'الدفع عند الاستلام',
              iconType: FontAwesomeIcons.handHoldingDollar.data,
              onTap: () =>
                  BuildNavigatorPush.build(
                      link: PaymentInvoiceScreen(isPaid: false),
                      context: context
                  )
          )
        ],
      ),
    );
  }
}
