import '../constants/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class PaymentStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveCardDetails({
    required String cardNumber,
    required String expiry,
    required String cardHolder,
  }) async {
    await _secureStorage.write(
      key: StorageKeys.cardNumber,
      value: cardNumber.replaceAll(' ', ''),
    );
    await _secureStorage.write(
      key: StorageKeys.cardExpiry,
      value: expiry.replaceAll('/', ''),
    );
    await _secureStorage.write(
      key: StorageKeys.cardHolder,
      value: cardHolder,
    );
  }

  Future<void> deleteCardDetails() async {
    await _secureStorage.delete(key: StorageKeys.cardNumber);
    await _secureStorage.delete(key: StorageKeys.cardExpiry);
    await _secureStorage.delete(key: StorageKeys.cardHolder);
  }

  Future<Map<String, String?>> getSavedCard() async {
    final cardNumber = await _secureStorage.read(key: StorageKeys.cardNumber);
    final expiry = await _secureStorage.read(key: StorageKeys.cardExpiry);
    final cardHolder = await _secureStorage.read(key: StorageKeys.cardHolder);

    return {
      'cardNumber': cardNumber,
      'expiry': expiry,
      'cardHolder': cardHolder,
    };
  }

  String formatCardNumber(String number) {
    var buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if ((i + 1) % 4 == 0 && i != number.length - 1) buffer.write(' ');
    }
    return buffer.toString();
  }

  String formatExpiryDate(String expiry) {
    if (expiry.length >= 2) {
      return '${expiry.substring(0, 2)}/${expiry.length > 2 ? expiry.substring(2) : ''}';
    }
    return expiry;
  }
}