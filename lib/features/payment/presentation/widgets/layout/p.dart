import '../card_form_widget.dart';
import '../mobile_form_widget.dart';
import '../payment_amount_widget.dart';
import '../payment_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../payment_method_selector.dart';
import '../../providers/payment_provider.dart';
import '../payment_security_message_widget.dart';
import '../../../constants/payment_constants.dart';
import '../../../constants/payment_dimensions.dart';
import '../../../../../core/presentation/widgets/back_button_widget.dart';


class PaymentLayout extends StatelessWidget {
  const PaymentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);
    final isCard = provider.selectedPaymentMethod ==
        PaymentConstants.paymentMethodCard;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الدفع الإلكتروني'),
          centerTitle: true,
          leading: BackButtonWidget(
            onPressed: provider.isLoading
                ? null
                : () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: PaymentDimensions.defaultPadding,
          child: Form(
            key: provider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentDimensions.verticalSpacing20,

                // عرض المبلغ الإجمالي
                PaymentAmountWidget(amount: provider.totalAmount),

                PaymentDimensions.verticalSpacing30,

                // اختيار طريقة الدفع
                PaymentMethodSelector(
                  selectedPaymentMethod: provider.selectedPaymentMethod,
                  onMethodSelected: (method) {
                    provider.selectedPaymentMethod = method;
                  },
                ),

                // عرض نموذج البطاقة أو الموبايل حسب الاختيار
                if (isCard)
                  CardFormWidget(
                    cardNumberController: provider.cardNumberController,
                    expiryController: provider.expiryController,
                    cvvController: provider.cvvController,
                    cardHolderController: provider.cardHolderController,
                    saveCard: provider.saveCard,
                    onSaveCardChanged: (value) {
                      provider.saveCard = value;
                    },
                  )
                else
                  MobileFormWidget(
                    phoneController: provider.phoneController,
                    emailController: provider.emailController,
                  ),

                PaymentDimensions.verticalSpacing30,

                // زر الدفع
                PaymentButtonWidget(
                  isLoading: provider.isLoading,
                  selectedMethod: provider.selectedPaymentMethod,
                  onPressed: () {
                    provider.processPayment(context);
                  },
                ),

                PaymentDimensions.verticalSpacing20,

                // رسالة الأمان
                const PaymentSecurityMessageWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}