class ApiConstants {
  // Paymob API Endpoints
  static const String paymobAuthUrl = 'https://accept.paymob.com/api/auth/tokens';
  static const String paymobOrderUrl = 'https://accept.paymob.com/api/ecommerce/orders';
  static const String paymobPaymentKeyUrl = 'https://accept.paymob.com/api/acceptance/payment_keys';
  static const String paymobPayUrl = 'https://accept.paymob.com/api/acceptance/payments/pay';

  // Fawry API Endpoint
  static const String fawryUrl = 'https://atfawry.fawrystaging.com/ECommerceWeb/Fawry/payments/charge';

  // API Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}