import 'package:geocoding/geocoding.dart';


class LocationFormatter {
  static String formatArabicAddress(Placemark place) {
    List<String> parts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      parts.add("شارع ${place.street}");
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    }

    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }

    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      parts.add(place.administrativeArea!);
    }

    return parts.isNotEmpty ? parts.join('، ') : "عنوان غير معروف";
  }

  static String formatLocationError(String error) {
    if (error.contains('permission')) {
      return 'يجب منح إذن الوصول إلى الموقع';
    } else if (error.contains('service')) {
      return 'خدمة الموقع غير مفعلة';
    }
    return error;
  }
}