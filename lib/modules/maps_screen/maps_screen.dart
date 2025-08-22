import 'package:flutter/material.dart';
import 'package:international_cuisine/layout/payment_ways.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/local/shared_preferences.dart';


class FixedLocationPicker extends StatefulWidget {
  @override
  _FixedLocationPickerState createState() => _FixedLocationPickerState();
}

class _FixedLocationPickerState extends State<FixedLocationPicker> {
  String _currentAddress = "جاري تحديد موقعك...";
  bool _isLoading = false;
  loc.LocationData? _currentLocation;
  GoogleMapController? _mapController;
  final loc.Location _locationService = loc.Location();

  Set<Marker> _markers = {};
  LatLng? _initialPosition;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _loadSavedLocation();
    await _getCurrentLocation();
  }

  Future<void> _loadSavedLocation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final savedAddress = prefs.getString('saved_address');

      if (savedAddress != null && savedAddress.isNotEmpty) {
        setState(() {
          _currentAddress = savedAddress;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved location: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _currentAddress = "جاري تحديد الموقع...";
    });

    try {
      // 1. Check if location service is enabled
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          throw 'Location services are disabled';
        }
      }

      // 2. Check and request permission
      final status = await _locationService.requestPermission();

      if (status != loc.PermissionStatus.granted &&
          status != loc.PermissionStatus.grantedLimited) {
        if (status == loc.PermissionStatus.deniedForever) {
          await openAppSettings();
        }
        throw 'يجب منح إذن الوصول إلى الموقع';
      }

      // 3. Get current location
      _currentLocation = await _locationService.getLocation();

      // 4. Update map
      _updateMapPosition(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      );

      // 5. Get address
      await _getAddressFromCoordinates(_currentLocation!);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = "خطأ: ${e.toString()}";
      });
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getAddressFromCoordinates(loc.LocationData location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude!,
        location.longitude!,
      );

      if (placemarks.isEmpty) {
        throw 'No address found for this location';
      }

      Placemark place = placemarks[0];

      if (!mounted) return;
      setState(() {
        _currentAddress = _formatArabicAddress(place);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = "لا يمكن عرض العنوان";
      });
      debugPrint('Geocoding error: $e');
    }
  }

  String _formatArabicAddress(Placemark place) {
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

  void _updateMapPosition(LatLng position) {
    if (!mounted) return;

    setState(() {
      _initialPosition = position;
      _markers = {
        Marker(
          markerId: MarkerId('current'),
          position: position,
          infoWindow: InfoWindow(title: 'موقعك الحالي'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, 16),
    );
  }

  Future<void> _saveLocation() async {
    if (_currentLocation == null || _currentAddress.isEmpty) return;

    try {
      await CacheHelper.setString(key: 'saved_address', value: _currentAddress);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم حفظ العنوان بنجاح"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaymentWays()));
    } catch (e) {
      if (!mounted) return;
      _showError('فشل في حفظ العنوان');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("خطأ"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("حسناً"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حدد موقع التوصيل"),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'الموقع الحالي',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _initialPosition == null
                ? _buildLoadingView()
                : GoogleMap(
              onMapCreated: (ctrl) => _mapController = ctrl,
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 16,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: (pos) {
                _updateMapPosition(pos);
                _getAddressFromCoordinates(
                  loc.LocationData.fromMap({
                    'latitude': pos.latitude,
                    'longitude': pos.longitude,
                  }),
                );
              },
            ),
          ),
          _buildAddressPanel(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("جاري تحميل الخريطة..."),
        ],
      ),
    );
  }

  Widget _buildAddressPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
        BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, -5))
        ],
      ),
      child: Column(
        children: [
          if (_isLoading) LinearProgressIndicator(),
          SizedBox(height: 12),
          Text(
            "العنوان المحدد:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _currentAddress,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.refresh,
                label: "تحديث",
                onPressed: _getCurrentLocation,
              ),
              _buildActionButton(
                icon: Icons.save,
                label: "حفظ",
                onPressed: _isLoading || _currentAddress.isEmpty
                    ? null
                    : _saveLocation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: onPressed,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}