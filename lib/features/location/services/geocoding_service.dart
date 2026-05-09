import 'package:geocoding/geocoding.dart';


class GeocodingService {
  Future<Placemark> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('No address found for this location');
      }

      return placemarks[0];
    } catch (e) {
      throw Exception('Failed to get address: $e');
    }
  }

  Future<Placemark> getAddressFromLocationData(LocationData location) async {
    return await getAddressFromCoordinates(
      latitude: location.latitude!,
      longitude: location.longitude!,
    );
  }
}

// نموذج بيانات مؤقت
class LocationData {
  final double? latitude;
  final double? longitude;

  LocationData({this.latitude, this.longitude});

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}