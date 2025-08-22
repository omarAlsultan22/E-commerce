import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:international_cuisine/layout/delivery_layout.dart';
import 'package:international_cuisine/modules/payment_screen/payment_screen.dart';
import 'package:international_cuisine/shared/components/components.dart';

class PaymentWays extends StatelessWidget {
  const PaymentWays({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختر طريق الدفع'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          container(iconName: 'الدفع الالكتروني',
              iconType: Icons.credit_card,
              onTap: () => navigator(link: PaymentScreen(), context: context)),
          container(iconName: 'الدفع عند الاستلام',
              iconType: FontAwesomeIcons.handHoldingUsd,
              onTap: () =>
                  navigator(link: PaymentInvoice(title: 'لم يتم الدفع!',),
                      context: context))
        ],
      ),
    );
  }

  Widget container({
    required String iconName,
    required IconData iconType,
    required VoidCallback onTap,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200.0,
          width: double.infinity,
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                Icon(iconType),
                Text(iconName)
              ],
            ),
          ),
        ),
      );
}
