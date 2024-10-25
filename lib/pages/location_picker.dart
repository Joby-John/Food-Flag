import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final Function(String) onLocationSelected;

  MapScreen({required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng currentLocation = LatLng(37.7749, -122.4194); // Default: San Francisco
  Marker? selectedMarker;

  Future<void> GetCurrentLocation() async {
    Location location = Location();

    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });

      // Move the map to the new location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(currentLocation),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      // Use default location or handle error
    }
  }

  @override
  void initState() {
    super.initState();
    GetCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Move the map to the current location once the map is created
    if (currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    }
  }

  void _onLocationPick(LatLng latLng) {
    setState(() {
      selectedMarker = Marker(
        markerId: MarkerId("selected-location"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }

  void _confirmLocation() {
    if (selectedMarker != null) {
      widget.onLocationSelected(
          '${selectedMarker!.position.latitude}, ${selectedMarker!.position.longitude}');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a location on the map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmLocation, // Confirm and pass the location
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 13,
        ),
        markers: selectedMarker != null ? {selectedMarker!} : {},
        onTap: _onLocationPick,
      ),
    );
  }
}
