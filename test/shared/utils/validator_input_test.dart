import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/shared/utils/validator_input.dart';


void main() {
  group('ValidateInput.validator', () {
    test('returns error message when value is null', () {
      final result = ValidateInput.validator(null, 'الاسم');

      expect(result, 'يرجي أدخال الاسم');
    });

    test('returns error message when value is empty', () {
      final result = ValidateInput.validator('', 'البريد');

      expect(result, 'يرجي أدخال البريد');
    });

    test('returns null when value is not empty', () {
      final result = ValidateInput.validator('علي', 'الاسم');

      expect(result, isNull);
    });

    test('includes fieldName in error message', () {
      final result = ValidateInput.validator('', 'كلمة المرور');

      expect(result, contains('كلمة المرور'));
    });

    test('returns null for whitespace-only string (documents behavior)', () {
      // '   ' ليست فارغة (isEmpty == false) → null
      final result = ValidateInput.validator('   ', 'الاسم');

      expect(result, isNull);
    });
  });
}