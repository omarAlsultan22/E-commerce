import 'dart:convert';
import '../constants/app_strings.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/api_json_keys.dart';
import '../constants/fawry_constants.dart';
import '../constants/payment_constants.dart';


class FawryService {
  Future<String> createFawryPayment({
    required String phoneNumber,
    required String email,
    required double amount,
  }) async {
    final response = await http.post(
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
      throw Exception(AppStrings.createFawryInvoiceError);
    }
  }
}