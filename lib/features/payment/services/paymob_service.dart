import 'dart:convert';
import '../constants/payment_strings.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/api_json_keys.dart';
import '../constants/paymob_constants.dart';
import '../constants/payment_constants.dart';


class PaymobService {
  Future<String> getAuthToken() async {
    final response = await http.post(
      Uri.parse(ApiConstants.paymobAuthUrl),
      headers: {ApiConstants.contentType: ApiConstants.applicationJson},
      body: json.encode({ApiJsonKeys.apiKey: PaymobConstants.apiKey}),
    );

    if (response.statusCode != 201) {
      throw Exception(PaymentStrings.paymentTokenError);
    }

    return json.decode(response.body)[ApiJsonKeys.token];
  }

  Future<int> createOrder(String authToken, double amount) async {
    final response = await http.post(
      Uri.parse(ApiConstants.paymobOrderUrl),
      headers: {ApiConstants.contentType: ApiConstants.applicationJson},
      body: json.encode({
        ApiJsonKeys.authToken: authToken,
        ApiJsonKeys.deliveryNeeded: 'false',
        ApiJsonKeys.amountCents: (amount * 100).round().toString(),
        ApiJsonKeys.currency: PaymentConstants.defaultCurrency,
        ApiJsonKeys.items: [
          {
            ApiJsonKeys.name: 'International Cuisine Order',
            ApiJsonKeys.amountCents: (amount * 100).round().toString(),
            ApiJsonKeys.quantity: '1',
          }
        ],
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(PaymentStrings.createOrderError);
    }

    return json.decode(response.body)[ApiJsonKeys.id];
  }

  Future<String> getPaymentKey({
    required String authToken,
    required int orderId,
    required double amount,
    required Map<String, dynamic> billingData,
    required String integrationId,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.paymobPaymentKeyUrl),
      headers: {ApiConstants.contentType: ApiConstants.applicationJson},
      body: json.encode({
        ApiJsonKeys.authToken: authToken,
        ApiJsonKeys.amountCents: (amount * 100).round().toString(),
        ApiJsonKeys.expiration: PaymentConstants.paymentExpirationSeconds,
        ApiJsonKeys.orderId: orderId,
        ApiJsonKeys.billingData: billingData,
        ApiJsonKeys.currency: PaymentConstants.defaultCurrency,
        ApiJsonKeys.integrationId: integrationId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(PaymentStrings.createPaymentKeyError);
    }

    return json.decode(response.body)[ApiJsonKeys.token];
  }

  Future<void> initiateVodafonePayment({
    required String phoneNumber,
    required String paymentToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.paymobPayUrl),
      headers: {ApiConstants.contentType: ApiConstants.applicationJson},
      body: json.encode({
        ApiJsonKeys.source: {
          ApiJsonKeys.identifier: phoneNumber,
          ApiJsonKeys.subtype: 'WALLET',
        },
        ApiJsonKeys.paymentToken: paymentToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(PaymentStrings.vodafonePaymentError);
    }
  }
}