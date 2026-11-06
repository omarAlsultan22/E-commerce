import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/payment/presentation/formatters/payment_formatters.dart';


void main() {
  group('CardNumberFormatter', () {
    late CardNumberFormatter formatter;

    setUp(() {
      formatter = CardNumberFormatter();
    });

    TextEditingValue format(String text) {
      return formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: text),
      );
    }

    test('returns empty for empty input', () {
      expect(format('').text, '');
    });

    test('does not add space for 1-4 digits', () {
      expect(format('1234').text, '1234');
    });

    test('adds space after 4 digits', () {
      expect(format('12345').text, '1234 5');
    });

    test('adds spaces every 4 digits', () {
      expect(format('1234567890123456').text, '1234 5678 9012 3456');
    });

    test('truncates beyond max length', () {
      // cardNumberMaxLength — افترض 16
      expect(format('12345678901234567890').text, '1234 5678 9012 3456');
    });

    test('strips existing spaces before formatting', () {
      expect(format('1234 5678').text, '1234 5678');
    });

    test('selection is at end of formatted text', () {
      final result = format('12345');
      expect(result.selection.baseOffset, result.text.length);
    });
  });

  group('CardExpiryFormatter', () {
    late CardExpiryFormatter formatter;

    setUp(() {
      formatter = CardExpiryFormatter();
    });

    TextEditingValue format(String text) {
      return formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: text),
      );
    }

    test('returns empty for empty input', () {
      expect(format('').text, '');
    });

    test('does not add slash for 1 digit', () {
      expect(format('1').text, '1');
    });

    test('does not add slash for 2 digits (no trailing slash)', () {
      expect(format('12').text, '12');
    });

    test('adds slash after 2 digits when more digits follow', () {
      expect(format('123').text, '12/3');
    });

    test('formats full expiry date', () {
      expect(format('1225').text, '12/25');
    });

    test('truncates beyond max length', () {
      // expiryMaxLength — افترض 4
      expect(format('122599').text, '12/25');
    });

    test('strips existing slashes before formatting', () {
      expect(format('12/25').text, '12/25');
    });

    test('selection is at end of formatted text', () {
      final result = format('123');
      expect(result.selection.baseOffset, result.text.length);
    });
  });
}