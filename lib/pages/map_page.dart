import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:FoodFlag/services/auth.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _defaultLocation = LatLng(8.91265639925882, 76.63124399172435);
  Set<Marker> dbmarkers = {};
  LocationData? currentLocation;
  bool isRefreshing = false; // Flag to track ongoing refresh

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    fetchData();
  }

  void getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    setState(() {});
    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
    });
  }

  Future<void> fetchData() async {
    // Check if a refresh is already in progress
    if (isRefreshing) {
      return; // Skip refresh if already refreshing
    }

    // Set the flag to indicate ongoing refresh
    setState(() {
      isRefreshing = true;
    });

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');//initialization of instance for getting the user collection

    QuerySnapshot usersSnapshot = await usersRef.get(); //getting all the documents in user collection without any condition

    Set<Marker> newMarkers = {};
    for (var userDoc in usersSnapshot.docs) { //iterating over each document
      CollectionReference markersRef = userDoc.reference.collection('markers'); //getting marker subcollection and initialising it to markersRef
      QuerySnapshot markersSnapshot = await markersRef.get();//getting all the marker documents without any condition

      for (var markerDoc in markersSnapshot.docs) {//iterating over each marker document
        GeoPoint geoPoint = markerDoc['coordinates'];//extracting geopoint from coordinate field
        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);// storing geopoint to latlng object position

        Marker newMarker = Marker(
          markerId: MarkerId(markerDoc.id),
          position: position,
        );
        newMarkers.add(newMarker);// adding new marker object
      }
    }

    setState(() {
      dbmarkers = Set.from(newMarkers);//updating dbmarkers with new markers obtained
      isRefreshing = false; // Reset the flag after refresh is completed
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        scrollGesturesEnabled: true,
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 13),
        zoomControlsEnabled: false,
        markers: {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            onTap: () {
              Navigator.pushNamed(context, authState.currentUser?.email == null ? '/settingspage' : '/hoistpage');
            },
          ),
          ...dbmarkers
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isRefreshing ? null : fetchData, // Disable button during ongoing refresh
        child: Icon(Icons.refresh),
      ),
    );
  }
}
