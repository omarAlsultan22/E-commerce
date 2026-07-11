import 'package:flutter/material.dart';
import '../../constants/payment_strings.dart';
import '../../constants/payment_dimensions.dart';


class MobileFormWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const MobileFormWidget({
    super.key,
    required this.phoneController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentDimensions.verticalSpacing20,
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: PaymentStrings.phoneNumber,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
            hintText: '01012345678',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return PaymentStrings.pleaseEnterPhoneNumber;
            }
            if (!RegExp(r'^01[0-2,5]{1}[0-9]{8}$').hasMatch(value)) {
              return PaymentStrings.invalidPhoneNumber;
            }
            return null;
          },
        ),
        PaymentDimensions.verticalSpacing15,
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: PaymentStrings.email,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return PaymentStrings.pleaseEnterEmail;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return PaymentStrings.invalidEmail;
            }
            return null;
          },
        ),
      ],
    );
  }
}