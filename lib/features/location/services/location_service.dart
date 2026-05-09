import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';


class LocationService {
  final loc.Location _locationService = loc.Location();

  Future<bool> isLocationServiceEnabled() async {
    return await _locationService.serviceEnabled();
  }

  Future<bool> requestLocationService() async {
    return await _locationService.requestService();
  }

  Future<loc.PermissionStatus> requestPermission() async {
    return await _locationService.requestPermission();
  }

  Future<loc.LocationData?> getCurrentLocation() async {
    try {
      return await _locationService.getLocation();
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  Future<bool> checkAndRequestPermissions() async {
    // Check if location service is enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await requestLocationService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
    }

    // Check and request permission
    final status = await requestPermission();

    if (status != loc.PermissionStatus.granted &&
        status != loc.PermissionStatus.grantedLimited) {
      if (status == loc.PermissionStatus.deniedForever) {
        await openAppSettings();
      }
      throw Exception('Location permission denied');
    }

    return true;
  }
}