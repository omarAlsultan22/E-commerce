class PaymentConstants {
  // Payment Configuration
  static const String defaultCurrency = 'EGP';
  static const String defaultCountry = 'EG';
  static const String defaultCity = 'Cairo';
  static const int paymentExpirationSeconds = 3600; // 1 hour in seconds
  static const int fawryExpirationDays = 3;
  static const double defaultVerticalSpacing = 10.0;
  static const double defaultVerticalSpacingLarge = 15.0;
  static const double defaultVerticalSpacingExtraLarge = 20.0;
  static const double defaultHorizontalSpacing = 8.0;
  static const int cardNumberMaxLength = 16;
  static const int cvvMaxLength = 3;
  static const int expiryMaxLength = 4;

  // Default Test Values
  static const String testCardNumber = '4242424242424242';
  static const String testExpiryDate = '12/30';
  static const String testCardHolder = 'payment test';
  static const String testCvv = '123';
  static const String testEmail = 'test+paymob@example.com';
  static const String testPhone = '01126487652';

  // Payment Methods
  static const int paymentMethodCard = 0;
  static const int paymentMethodFawry = 1;
  static const int paymentMethodVodafone = 2;
}