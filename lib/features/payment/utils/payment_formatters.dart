import 'package:flutter/services.dart';
import 'package:international_cuisine/features/payment/constants/payment_constants.dart';


class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > PaymentConstants.cardNumberMaxLength)
      text = text.substring(0, PaymentConstants.cardNumberMaxLength);

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write(' ');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}


class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > PaymentConstants.expiryMaxLength)
      text = text.substring(0, PaymentConstants.expiryMaxLength);

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i != text.length - 1) buffer.write('/');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}