import '../data/models/data_model.dart';


class SizePriceCalculator {
  static num calculatePrice(DataModel dataModel, int currentSizeIndex) {
    switch (currentSizeIndex) {
      case 0:
        return dataModel.orderPrice! * 0.8;
      case 1:
        return dataModel.orderPrice!;
      case 2:
        return dataModel.orderPrice! * 1.2;
      default:
        return dataModel.orderPrice!;
    }
  }
}