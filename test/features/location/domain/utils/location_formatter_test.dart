import 'package:geocoding/geocoding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/location/domain/utils/location_formatter.dart';


void main() {
  group('formatArabicAddress', () {
    test('returns "عنوان غير معروف" when all fields are empty', () {
      final place = Placemark();

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'عنوان غير معروف');
    });

    test('returns "عنوان غير معروف" when all fields are null', () {
      final place = Placemark(
        street: null,
        subLocality: null,
        locality: null,
        administrativeArea: null,
      );

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'عنوان غير معروف');
    });

    test('includes street only', () {
      final place = Placemark(street: 'Tahrir');

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'شارع Tahrir');
    });

    test('includes subLocality only', () {
      final place = Placemark(subLocality: 'Zamalek');

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'Zamalek');
    });

    test('includes locality only', () {
      final place = Placemark(locality: 'Cairo');

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'Cairo');
    });

    test('includes administrativeArea only', () {
      final place = Placemark(administrativeArea: 'Cairo Governorate');

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'Cairo Governorate');
    });

    test('joins multiple fields with Arabic comma', () {
      final place = Placemark(
        street: 'Tahrir',
        subLocality: 'Zamalek',
        locality: 'Cairo',
        administrativeArea: 'Cairo Governorate',
      );

      final result = LocationFormatter.formatArabicAddress(place);

      expect(
        result,
        'شارع Tahrir، Zamalek، Cairo، Cairo Governorate',
      );
    });

    test('skips empty fields and joins remaining', () {
      final place = Placemark(
        street: '',
        subLocality: 'Zamalek',
        locality: '',
        administrativeArea: 'Cairo Governorate',
      );

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, 'Zamalek، Cairo Governorate');
    });

    test('prepends "شارع " to street', () {
      final place = Placemark(street: 'Nile');

      final result = LocationFormatter.formatArabicAddress(place);

      expect(result, startsWith('شارع '));
      expect(result, contains('Nile'));
    });
  });

  group('formatLocationError', () {
    test('returns Arabic message when error contains "permission"', () {
      final result = LocationFormatter.formatLocationError('Location permission denied');

      expect(result, 'يجب منح إذن الوصول إلى الموقع');
    });

    test('returns Arabic message when error contains "service"', () {
      final result = LocationFormatter.formatLocationError('Location service disabled');

      expect(result, 'خدمة الموقع غير مفعلة');
    });

    test('returns original error when no match', () {
      final result = LocationFormatter.formatLocationError('Unknown error');

      expect(result, 'Unknown error');
    });

    test('prioritizes "permission" over "service"', () {
      final result = LocationFormatter.formatLocationError('permission and service error');

      expect(result, 'يجب منح إذن الوصول إلى الموقع');
    });

    test('is case-sensitive', () {
      final result = LocationFormatter.formatLocationError('PERMISSION');

      expect(result, 'PERMISSION');  // ← لا يطابق 'permission'
    });
  });
}