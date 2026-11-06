import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:international_cuisine/features/payment/data/services/fawry_service.dart';

void main() {
  group('createFawryPayment', () {
    test('returns referenceNumber on 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode({'referenceNumber': 'REF-123'}),
          200,
        );
      });
      final service = FawryService(client: mockClient);

      final result = await service.createFawryPayment(
        phoneNumber: '0123456789',
        email: 'a@b.com',
        amount: 100.0,
      );

      expect(result, 'REF-123');
    });

    test('throws Exception on non-200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 400);
      });
      final service = FawryService(client: mockClient);

      expect(
            () => service.createFawryPayment(
          phoneNumber: '0123456789',
          email: 'a@b.com',
          amount: 100.0,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('sends correct request body', () async {
      http.Request? capturedRequest;
      final mockClient = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          json.encode({'referenceNumber': 'REF-123'}),
          200,
        );
      });
      final service = FawryService(client: mockClient);

      await service.createFawryPayment(
        phoneNumber: '0123456789',
        email: 'a@b.com',
        amount: 100.0,
      );

      final body = json.decode(capturedRequest!.body);
      expect(body['customerMobile'], '0123456789');
      expect(body['customerEmail'], 'a@b.com');
      expect(body['amount'], '100.0');
    });

    test('sends POST to correct URL', () async {
      Uri? capturedUrl;
      final mockClient = MockClient((request) async {
        capturedUrl = request.url;
        return http.Response(
          json.encode({'referenceNumber': 'REF-123'}),
          200,
        );
      });
      final service = FawryService(client: mockClient);

      await service.createFawryPayment(
        phoneNumber: '0123456789',
        email: 'a@b.com',
        amount: 100.0,
      );

      expect(capturedUrl.toString(), contains('fawry'));
    });

    test('includes Content-Type header', () async {
      Map<String, String>? capturedHeaders;
      final mockClient = MockClient((request) async {
        capturedHeaders = request.headers;
        return http.Response(
          json.encode({'referenceNumber': 'REF-123'}),
          200,
        );
      });
      final service = FawryService(client: mockClient);

      await service.createFawryPayment(
        phoneNumber: '0123456789',
        email: 'a@b.com',
        amount: 100.0,
      );

      expect(capturedHeaders!['Content-Type'], 'application/json');
    });
  });
}