import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import '../services/geocoding_service.dart';
import '../services/location_service.dart';
import 'package:geocoding/geocoding.dart';
import '../utils/location_formatter.dart';
import 'dart:async';


class LocationManager {
  final LocationService _locationService = LocationService();
  final GeocodingService _geocodingService = GeocodingService();

  final StreamController<LocationState> _stateController = StreamController.broadcast();
  Stream<LocationState> get stateStream => _stateController.stream;

  LocationState _currentState = LocationState.initial();
  LocationState get currentState => _currentState;

  void _updateState(LocationState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  Future<void> initializeLocation() async {
    _updateState(LocationState.loading());

    try {
      await _locationService.checkAndRequestPermissions();
      final loc.LocationData? locationData = await _locationService.getCurrentLocation();

      if (locationData != null) {
        final position = LatLng(locationData.latitude!, locationData.longitude!);
        final placemark = await _geocodingService.getAddressFromCoordinates(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        );
        final formattedAddress = LocationFormatter.formatArabicAddress(placemark);

        _updateState(LocationState.success(
          position: position,
          address: formattedAddress,
          placemark: placemark,
        ));
      } else {
        _updateState(LocationState.error(message: 'Failed to get location'));
      }
    } catch (e) {
      _updateState(LocationState.error(message: e.toString()));
    }
  }

  Future<void> updatePosition(LatLng position) async {
    _updateState(LocationState.loading());

    try {
      final placemark = await _geocodingService.getAddressFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      final formattedAddress = LocationFormatter.formatArabicAddress(placemark);

      _updateState(LocationState.success(
        position: position,
        address: formattedAddress,
        placemark: placemark,
      ));
    } catch (e) {
      _updateState(LocationState.error(message: e.toString()));
    }
  }

  void dispose() {
    _stateController.close();
  }
}

class LocationState {
  final bool isLoading;
  final String address;
  final LatLng? position;
  final String? errorMessage;
  final Placemark? placemark;

  LocationState({
    required this.isLoading,
    required this.address,
    this.position,
    this.errorMessage,
    this.placemark,
  });

  factory LocationState.initial() {
    return LocationState(
      isLoading: false,
      address: "جاري تحديد موقعك...",
    );
  }

  factory LocationState.loading() {
    return LocationState(
      isLoading: true,
      address: "جاري تحديد الموقع...",
    );
  }

  factory LocationState.success({
    required LatLng position,
    required String address,
    required Placemark placemark,
  }) {
    return LocationState(
      isLoading: false,
      address: address,
      position: position,
      placemark: placemark,
    );
  }

  factory LocationState.error({
    required String message,
  }) {
    return LocationState(
      isLoading: false,
      address: "خطأ: $message",
      errorMessage: message,
    );
  }
}