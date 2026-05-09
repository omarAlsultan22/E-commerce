import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_dimensions.dart';
import '../../utils/payment_formatters.dart';
import '../../constants/payment_constants.dart';


class CardFormWidget extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final TextEditingController cardHolderController;
  final bool saveCard;
  final Function(bool) onSaveCardChanged;

  const CardFormWidget({
    super.key,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.cardHolderController,
    required this.saveCard,
    required this.onSaveCardChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDimensions.verticalSpacing20,
        TextFormField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(PaymentConstants.cardNumberMaxLength),
            CardNumberFormatter(),
          ],
          decoration: const InputDecoration(
            labelText: AppStrings.cardNumber,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.pleaseEnterCardNumber;
            }
            if (value.replaceAll(' ', '').length != PaymentConstants.cardNumberMaxLength) {
              return AppStrings.cardNumberMustBe16Digits;
            }
            return null;
          },
        ),
        AppDimensions.verticalSpacing15,
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: expiryController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(PaymentConstants.expiryMaxLength),
                  CardExpiryFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: AppStrings.expiryDate,
                  border: OutlineInputBorder(),
                  hintText: 'MM/YY',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterExpiryDate;
                  }
                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                    return AppStrings.invalidExpiryFormat;
                  }
                  return null;
                },
              ),
            ),
            AppDimensions.horizontalSpacing15,
            Expanded(
              child: TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(PaymentConstants.cvvMaxLength),
                ],
                decoration: const InputDecoration(
                  labelText: AppStrings.cvv,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterCvv;
                  }
                  if (value.length != PaymentConstants.cvvMaxLength) {
                    return AppStrings.cvvMustBe3Digits;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        AppDimensions.verticalSpacing15,
        TextFormField(
          controller: cardHolderController,
          decoration: const InputDecoration(
            labelText: AppStrings.cardHolderName,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.pleaseEnterCardHolder;
            }
            return null;
          },
        ),
        AppDimensions.verticalSpacing10,
        CheckboxListTile(
          title: const Text(AppStrings.saveCard),
          value: saveCard,
          onChanged: (value) => onSaveCardChanged(value ?? false),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}