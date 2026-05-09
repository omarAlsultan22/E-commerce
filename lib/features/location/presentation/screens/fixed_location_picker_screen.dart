import 'package:international_cuisine/features/payment/presentation/screens/payment_way_selection_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/constants/app_keys.dart';
import '../../managers/location_manager.dart';
import '../widgets/address_panel_widget.dart';
import '../widgets/loading_view_widget.dart';
import 'package:flutter/material.dart';


class FixedLocationPicker extends StatefulWidget {
  final CacheHelper cacheHelper;

  const FixedLocationPicker({
    super.key,
    required this.cacheHelper,
  });

  @override
  State<FixedLocationPicker> createState() => _FixedLocationPickerState();
}

class _FixedLocationPickerState extends State<FixedLocationPicker> {
  late LocationManager _locationManager;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _locationManager = LocationManager();
    _initializeLocation();
    _listenToLocationChanges();
  }

  void _initializeLocation() async {
    await _loadSavedLocation();
    await _locationManager.initializeLocation();
  }

  Future<void> _loadSavedLocation() async {
    try {
      final savedAddress = await widget.cacheHelper.getStringValue(
        key: AppKeys.location,
      );

      if (savedAddress != null && savedAddress.isNotEmpty && mounted) {
        // Update the address in the location manager
        _locationManager = LocationManager(); // Re-initialize with saved address
      }
    } catch (e) {
      debugPrint('Error loading saved location: $e');
    }
  }

  void _listenToLocationChanges() {
    _locationManager.stateStream.listen((state) {
      if (!mounted) return;

      setState(() {}); // Trigger rebuild

      if (state.errorMessage != null) {
        _showErrorDialog(state.errorMessage!);
      }

      // Update map when position changes
      if (state.position != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(state.position!, 16.0),
        );
      }
    });
  }

  Future<void> _saveLocation() async {
    final currentState = _locationManager.currentState;

    if (currentState.position == null || currentState.address == null) return;

    try {
      await widget.cacheHelper.setStringValue(
        key: AppKeys.location,
        value: currentState.address!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حفظ العنوان بنجاح"),
          duration: Duration(seconds: 2),
        ),
      );

      navigator(
        context: context,
        link: const PaymentWaySelectionScreen(),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('فشل في حفظ العنوان');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("خطأ"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("حسناً"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) {
    _locationManager.updatePosition(position);
  }

  @override
  Widget build(BuildContext context) {
    final currentState = _locationManager.currentState;
    final isLoading = currentState.isLoading;
    final address = currentState.address ?? "جاري تحديد الموقع...";
    final position = currentState.position;
    final markers = position != null
        ? {
      Marker(
        markerId: const MarkerId('current'),
        position: position,
        infoWindow: const InfoWindow(title: 'موقعك الحالي'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ),
    }
        : <Marker>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text("حدد موقع التوصيل"),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _locationManager.initializeLocation,
            tooltip: 'الموقع الحالي',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: position == null || isLoading
                ? const LoadingViewWidget()
                : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 16.0,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: _onMapTap,
            ),
          ),
          AddressPanelWidget(
            isLoading: isLoading,
            address: address,
            onRefresh: _locationManager.initializeLocation,
            onSave: _saveLocation,
            isSaveEnabled: !isLoading && address.isNotEmpty && position != null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _locationManager.dispose();
    super.dispose();
  }
}