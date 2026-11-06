import 'dart:convert';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/payment/data/services/paymob_service.dart';


void main() {
  group('getAuthToken', () {
    test('returns token on 201 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          json.encode({'token': 'AUTH-TOKEN-123'}),
          201,
        );
      });
      final service = PaymobService(client: mockClient);

      final result = await service.getAuthToken();

      expect(result, 'AUTH-TOKEN-123');
    });

    test('throws Exception on non-201 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 400);
      });
      final service = PaymobService(client: mockClient);

      expect(() => service.getAuthToken(), throwsA(isA<Exception>()));
    });

    test('sends apiKey in request body', () async {
      http.Request? captured;
      final mockClient = MockClient((request) async {
        captured = request;
        return http.Response(json.encode({'token': 'T'}), 201);
      });
      final service = PaymobService(client: mockClient);

      await service.getAuthToken();

      final body = json.decode(captured!.body);
      expect(body['api_key'], isNotNull);
    });
  });

  group('createOrder', () {
    test('returns order id on 201 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(json.encode({'id': 12345}), 201);
      });
      final service = PaymobService(client: mockClient);

      final result = await service.createOrder('AUTH', 100.0);

      expect(result, 12345);
    });

    test('throws Exception on non-201 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 400);
      });
      final service = PaymobService(client: mockClient);

      expect(() => service.createOrder('AUTH', 100.0), throwsA(isA<Exception>()));
    });

    test('converts amount to cents', () async {
      http.Request? captured;
      final mockClient = MockClient((request) async {
        captured = request;
        return http.Response(json.encode({'id': 1}), 201);
      });
      final service = PaymobService(client: mockClient);

      await service.createOrder('AUTH', 100.5);

      final body = json.decode(captured!.body);
      expect(body['amount_cents'], '10050');  // 100.5 * 100 = 10050
    });

    test('includes auth token and items', () async {
      http.Request? captured;
      final mockClient = MockClient((request) async {
        captured = request;
        return http.Response(json.encode({'id': 1}), 201);
      });
      final service = PaymobService(client: mockClient);

      await service.createOrder('AUTH-TOKEN', 50.0);

      final body = json.decode(captured!.body);
      expect(body['auth_token'], 'AUTH-TOKEN');
      expect(body['items'], isA<List>());
    });
  });

  group('getPaymentKey', () {
    test('returns token on 201 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(json.encode({'token': 'PAYMENT-KEY'}), 201);
      });
      final service = PaymobService(client: mockClient);

      final result = await service.getPaymentKey(
        authToken: 'AUTH',
        orderId: 123,
        amount: 100.0,
        billingData: {'first_name': 'Ali'},
        integrationId: 'INT-1',
      );

      expect(result, 'PAYMENT-KEY');
    });

    test('throws Exception on non-201 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 400);
      });
      final service = PaymobService(client: mockClient);

      expect(
            () => service.getPaymentKey(
          authToken: 'AUTH',
          orderId: 123,
          amount: 100.0,
          billingData: {},
          integrationId: 'INT-1',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('includes billingData and integrationId in body', () async {
      http.Request? captured;
      final mockClient = MockClient((request) async {
        captured = request;
        return http.Response(json.encode({'token': 'T'}), 201);
      });
      final service = PaymobService(client: mockClient);

      await service.getPaymentKey(
        authToken: 'AUTH',
        orderId: 123,
        amount: 100.0,
        billingData: {'first_name': 'Ali'},
        integrationId: 'INT-1',
      );

      final body = json.decode(captured!.body);
      expect(body['billing_data'], {'first_name': 'Ali'});
      expect(body['integration_id'], 'INT-1');
    });
  });

  group('initiateVodafonePayment', () {
    test('completes on 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('OK', 200);
      });
      final service = PaymobService(client: mockClient);

      await expectLater(
        service.initiateVodafonePayment(
          phoneNumber: '0123456789',
          paymentToken: 'PAYMENT-TOKEN',
        ),
        completes,
      );
    });

    test('throws Exception on non-200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 400);
      });
      final service = PaymobService(client: mockClient);

      expect(
            () => service.initiateVodafonePayment(
          phoneNumber: '0123456789',
          paymentToken: 'PAYMENT-TOKEN',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('sends source with phone and WALLET subtype', () async {
      http.Request? captured;
      final mockClient = MockClient((request) async {
        captured = request;
        return http.Response('OK', 200);
      });
      final service = PaymobService(client: mockClient);

      await service.initiateVodafonePayment(
        phoneNumber: '0123456789',
        paymentToken: 'TOKEN',
      );

      final body = json.decode(captured!.body);
      expect(body['source']['identifier'], '0123456789');
      expect(body['source']['subtype'], 'WALLET');
      expect(body['payment_token'], 'TOKEN');
    });
  });
}