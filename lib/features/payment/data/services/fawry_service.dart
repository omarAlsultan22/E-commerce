import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../constants/api_json_keys.dart';
import '../../constants/payment_strings.dart';
import '../../constants/fawry_constants.dart';
import '../../constants/payment_constants.dart';


class FawryService {
  final http.Client _client;
  FawryService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> createFawryPayment({
    required String phoneNumber,
    required String email,
    required double amount,
  }) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.fawryUrl),
      headers: {ApiConstants.contentType: ApiConstants.applicationJson},
      body: json.encode({
        ApiJsonKeys.merchantCode: FawryConstants.merchantCode,
        ApiJsonKeys.merchantRefNum: 'REF-${DateTime.now().millisecondsSinceEpoch}',
        ApiJsonKeys.customerMobile: phoneNumber,
        ApiJsonKeys.customerEmail: email,
        ApiJsonKeys.paymentMethod: 'PayAtFawry',
        ApiJsonKeys.amount: amount.toString(),
        ApiJsonKeys.description: 'Payment for Order',
        ApiJsonKeys.paymentExpiry: DateTime.now()
            .add(Duration(days: PaymentConstants.fawryExpirationDays))
            .millisecondsSinceEpoch,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result[ApiJsonKeys.referenceNumber];
    } else {
      throw Exception(PaymentStrings.createFawryInvoiceError);
    }
  }
}