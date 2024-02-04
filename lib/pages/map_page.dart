import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _tkm = LatLng(8.91265639925882, 76.63124399172435);
  LocationData? currentLocation;
  

  void getCurrentLocation(){
    Location location = Location();
    location.getLocation().then((location)
    {
      currentLocation = location;
    },
    );
    location.onLocationChanged.listen((newLoc)
    {currentLocation = newLoc;
    setState(() {});
    },);
  }

  @override
  void initState()
  {
    getCurrentLocation();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: currentLocation == null
          ? const Center(child: Text("Loading")):
      GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 13), zoomControlsEnabled: false,
        markers: { Marker(
                 markerId: const MarkerId("currentLocation"),
        position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: (){Navigator.pushNamed(context, '/hoistpage');} ),
        },
      )
    );
  }
}
