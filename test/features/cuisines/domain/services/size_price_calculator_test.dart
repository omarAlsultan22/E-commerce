import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/features/cuisines/data/models/data_model.dart';
import 'package:international_cuisine/features/cuisines/domain/services/size_price_calculator.dart';


void main() {
  group('SizePriceCalculator.calculatePrice', () {
    test('returns 80% of price for size 0 (small)', () {
      final dataModel = DataModel(orderPrice: 100);

      final result = SizePriceCalculator.calculatePrice(dataModel, 0);

      expect(result, 80.0);
    });

    test('returns original price for size 1 (medium)', () {
      final dataModel = DataModel(orderPrice: 100);

      final result = SizePriceCalculator.calculatePrice(dataModel, 1);

      expect(result, 100);
    });

    test('returns 120% of price for size 2 (large)', () {
      final dataModel = DataModel(orderPrice: 100);

      final result = SizePriceCalculator.calculatePrice(dataModel, 2);

      expect(result, 120.0);
    });

    test('returns original price for invalid size index (default)', () {
      final dataModel = DataModel(orderPrice: 100);

      final result = SizePriceCalculator.calculatePrice(dataModel, 99);

      expect(result, 100);
    });

    test('handles negative size index (default)', () {
      final dataModel = DataModel(orderPrice: 100);

      final result = SizePriceCalculator.calculatePrice(dataModel, -1);

      expect(result, 100);
    });

    test('throws TypeError when orderPrice is null', () {
      final dataModel = DataModel(orderPrice: null);

      expect(
            () => SizePriceCalculator.calculatePrice(dataModel, 1),
        throwsA(isA<TypeError>()),  // ← orderPrice!
      );
    });

    test('handles decimal price for small size', () {
      final dataModel = DataModel(orderPrice: 99);

      final result = SizePriceCalculator.calculatePrice(dataModel, 0);

      // 99 * 0.8 = 79.2
      expect(result, closeTo(79.2, 0.01));
    });

    test('handles decimal price for large size', () {
      final dataModel = DataModel(orderPrice: 99);

      final result = SizePriceCalculator.calculatePrice(dataModel, 2);

      // 99 * 1.2 = 118.8
      expect(result, closeTo(118.8, 0.01));
    });
  });
}