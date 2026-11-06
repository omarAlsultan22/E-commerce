import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fakes/mock_flutter_secure_storage.dart';
import 'package:international_cuisine/features/payment/constants/storage_keys.dart';
import 'package:international_cuisine/features/payment/data/services/payment_storage_service.dart';


void main() {
  late MockFlutterSecureStorage mockStorage;
  late PaymentStorageService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = PaymentStorageService(secureStorage: mockStorage);
  });

  group('saveCardDetails', () {
    test('writes cardNumber without spaces', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.saveCardDetails(
        cardNumber: '1234 5678 9012 3456',
        expiry: '12/25',
        cardHolder: 'Ali Ahmed',
      );

      verify(() => mockStorage.write(
        key: StorageKeys.cardNumber,
        value: '1234567890123456',
      )).called(1);
    });

    test('writes expiry without slash', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.saveCardDetails(
        cardNumber: '1234',
        expiry: '12/25',
        cardHolder: 'Ali',
      );

      verify(() => mockStorage.write(
        key: StorageKeys.cardExpiry,
        value: '1225',
      )).called(1);
    });

    test('writes cardHolder as-is', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.saveCardDetails(
        cardNumber: '1234',
        expiry: '12/25',
        cardHolder: 'Ali Ahmed',
      );

      verify(() => mockStorage.write(
        key: StorageKeys.cardHolder,
        value: 'Ali Ahmed',
      )).called(1);
    });

    test('writes all three keys', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.saveCardDetails(
        cardNumber: '1234',
        expiry: '12/25',
        cardHolder: 'Ali',
      );

      verify(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .called(3);
    });
  });

  group('deleteCardDetails', () {
    test('deletes all three keys', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await service.deleteCardDetails();

      verify(() => mockStorage.delete(key: StorageKeys.cardNumber)).called(1);
      verify(() => mockStorage.delete(key: StorageKeys.cardExpiry)).called(1);
      verify(() => mockStorage.delete(key: StorageKeys.cardHolder)).called(1);
    });
  });

  group('getSavedCard', () {
    test('reads all three keys and returns map', () async {
      when(() => mockStorage.read(key: StorageKeys.cardNumber))
          .thenAnswer((_) async => '1234567890123456');
      when(() => mockStorage.read(key: StorageKeys.cardExpiry))
          .thenAnswer((_) async => '1225');
      when(() => mockStorage.read(key: StorageKeys.cardHolder))
          .thenAnswer((_) async => 'Ali');

      final result = await service.getSavedCard();

      expect(result['cardNumber'], '1234567890123456');
      expect(result['expiry'], '1225');
      expect(result['cardHolder'], 'Ali');
    });

    test('returns null values when not stored', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await service.getSavedCard();

      expect(result['cardNumber'], isNull);
      expect(result['expiry'], isNull);
      expect(result['cardHolder'], isNull);
    });
  });

  group('formatCardNumber', () {
    test('adds space every 4 digits', () {
      expect(service.formatCardNumber('1234567890123456'),
          '1234 5678 9012 3456');
    });

    test('does not add space at end', () {
      expect(service.formatCardNumber('1234'), '1234');
    });

    test('handles empty string', () {
      expect(service.formatCardNumber(''), '');
    });
  });

  group('formatExpiryDate', () {
    test('adds slash after 2 digits', () {
      expect(service.formatExpiryDate('1225'), '12/25');
    });

    test('handles exactly 2 digits', () {
      expect(service.formatExpiryDate('12'), '12');
    });

    test('handles less than 2 digits', () {
      expect(service.formatExpiryDate('1'), '1');
    });

    test('handles empty string', () {
      expect(service.formatExpiryDate(''), '');
    });
  });
}