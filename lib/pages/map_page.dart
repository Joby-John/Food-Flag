import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  // final Completer<GoogleMapController> _controller = Completer();
  // static const LatLng _defaultLocation = LatLng(8.91265639925882, 76.63124399172435);
  Set<Marker> dbmarkers = {};
  Set<Marker> allmarkers = {};
  LocationData? currentLocation;
  bool isRefreshing = false; // Flag to track ongoing refresh
  late AuthState authState;
  late User? user;
  late String userId;
  late var currUserDoc = null; // a default value of null so that if uninitialized its a null
  late StreamSubscription<QuerySnapshot>markerSubscription;

  @override
  void initState() {
    super.initState();
    authState = Provider.of<AuthState>(context, listen: false);
    user = authState.currentUser;
    userId = user?.uid??"";
    getCurrentLocation();
    listenForMarkerChanges();
    fetchData();
  }

  @override
  void dispose()
  {
    markerSubscription.cancel();
    super.dispose();
  }


  void getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();

    if(mounted)
      {
        setState(() {});
      }
    location.onLocationChanged.listen((newLoc) {
      if(mounted)
        {
          setState(() {
            currentLocation = newLoc;
          });
        }
    });
  }
  
  void listenForMarkerChanges()
  {
    markerSubscription = FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      Set<Marker> newMarkers = {};
      Set<Marker> ChangedSelfMarkers = {};

      for(var userDoc in snapshot.docs)
        {
          if(userId == null)
            {
              //logic for non-signed -in users
              continue;
            }

          if (userDoc.exists && userDoc.id != "Restaurant")
            {
              if(userDoc.id == userId)
                {
                  setState(() {
                    currUserDoc = userDoc;
                  });
                  if(currUserDoc != null)
                    {
                      Map<String, dynamic> selfmarkers = userDoc['markers'];

                      selfmarkers.forEach((markerId, data) {
                        GeoPoint geoPoint = data['location'];
                        LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
                        BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

                        Marker selfMarker = Marker(
                            markerId: MarkerId(markerId),
                            position: position,
                            icon: icon,
                            infoWindow: InfoWindow(
                              title: '$data["origin"] meal',
                              snippet: 'Type:${data["type"]}, Amount:${data["amount"]}',
                            ),
                          onTap: (){
                              _showSelfMarkerDialog(context, markerId, data);
                          },
                            );
                        ChangedSelfMarkers.add(selfMarker);
                      });
                    }
                }
              else
                {
                  Map<String, dynamic> markers = userDoc['markers'];
                  
                  markers.forEach((markerId, data)
                  {
                    GeoPoint geoPoint = data['location'];
                    LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
                    BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
                    
                    Marker newMarker = Marker(
                      markerId: MarkerId(markerId),
                      position:  position,
                      icon: icon,
                      infoWindow: InfoWindow(
                        title: '${data["Origin"]} meal',
                        snippet: 'Type:${data["type"]}, Amount:${data["amount"]}',
                      ),
                      onTap: (){
                        if(currUserDoc != null && currUserDoc['received'].length == 0)
                          {
                            _showMarkerDialog(context, markerId, data, userDoc.id);
                          }
                        else
                          {
                            _default(context);
                          }
                      },
                    );
                    newMarkers.add(newMarker);
                  });
                }
            }
        }

      if(mounted)
      {
        setState(() {
          dbmarkers = newMarkers;//updating dbmarkers with new markers obtained
          dbmarkers.addAll(ChangedSelfMarkers);//updating with self markers
          isRefreshing = false; // Reset the flag after refresh is completed
        });
        allmarkers.addAll(dbmarkers);
        fetchData();
      }
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
    Set<Marker> ChangedSelfMarkers = {};

      for (var userDoc in usersSnapshot.docs) {//iterating over each user document
        if (userId == null){
          // some logic here so that non signed in users cannot change the data
        }

        if (userDoc.exists && userDoc.id != "Restaurant") {
          // Access the markers map
          if(userDoc.id == userId) {
            setState(() {
              currUserDoc = userDoc; //curruserdoc exists in case of individual users
            });
            if (currUserDoc != null) // to avoid the null exception when its a restaurant user and currUserDoc is null
              {
              Map<String, dynamic> selfmarkers = userDoc['markers'];

            // Iterate through the markers and access the locations
            selfmarkers.forEach((markerId, data) {
              //print('Marker ID: $markerId, Location: $location');
              GeoPoint geoPoint = data['location'];
              LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
              // Create a BitmapDescriptor for the icon
              BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed);
              // Here you can perform operations with each marker location
              Marker selfMarker = Marker(
                  markerId: MarkerId(markerId),
                  position: position,
                  icon: icon,
                  // Assign the custom icon
                  infoWindow: InfoWindow(
                    title: '${data["origin"]} meal', // Example title
                    snippet: 'Type:${data["type"]}, Amount:${data["amount"]}', // Example snippet
                  ),
                  onTap: () {
                    _showSelfMarkerDialog(context, markerId, data);
                  }
              );
              ChangedSelfMarkers.add(selfMarker);
              print("LOOOOOOOOOOK HERE : $ChangedSelfMarkers");
            });
          }

                }
          else {
            Map<String, dynamic> markers = userDoc['markers'];

            // Iterate through the markers and access the locations
            markers.forEach((markerId, data) {
              //print('Marker ID: $markerId, Location: $location');
              GeoPoint geoPoint = data['location'];
              LatLng position = LatLng(geoPoint.latitude, geoPoint.longitude);
              // Create a BitmapDescriptor for the icon
              BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen);
              // Here you can perform operations with each marker location
              Marker newMarker = Marker(
                markerId: MarkerId(markerId),
                position: position,
                icon: icon,
                // Assign the custom icon
                infoWindow: InfoWindow(
                  title: '${data["origin"]} meal', // title
                  snippet: 'Type:${data["type"]}, Amount:${data["amount"]}', // snippet
                ),
                onTap: () {
                  if(currUserDoc!=null) { //to handle where currentuserdoc is null ie in case of restaurant user currentuserDoc will be null
                    if (currUserDoc['received'].length == 0) {
                      _showMarkerDialog(context, markerId, data, userDoc.id);
                    }
                    else {
                      _default(context);
                    }
                  }
                },
                // Add more properties as needed

              );
              newMarkers.add(newMarker); // adding new marker object
              print(newMarkers);
            });
            }
          } else {
          print('User document does not exist or does not contain markers.');
        }

      }


      setState(() {
        dbmarkers = newMarkers;//updating dbmarkers with new markers obtained
        dbmarkers.addAll(ChangedSelfMarkers);//updating with self markers
        isRefreshing = false; // Reset the flag after refresh is completed
      });


      allmarkers.addAll(dbmarkers);
  }

  @override
  Widget build(BuildContext context) {
    //final authState = Provider.of<AuthState>(context);
    return Scaffold(
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        scrollGesturesEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 13),
        zoomControlsEnabled: false,
        markers: allmarkers
    //{
        //   Marker(
        //     markerId: MarkerId("currentLocation"),
        //     position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        //     onTap: () {
        //       Navigator.pushNamed(context, authState.currentUser?.email == null ? '/settingspage' : '/hoistpage');
        //     },
        //   ),
        // },

      ),
      floatingActionButton: Align(alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: isRefreshing ? null : fetchData, // Disable button during ongoing refresh
        child: Icon(Icons.refresh),
      ),)
    );
  }

  Future<void> _showMarkerDialog(BuildContext context, String markerId, Map<String, dynamic> markerData, String owner_uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(owner_uid).get();
    showDialog(
      context: context,
      builder: (BuildContext context) {
      if (userDoc.exists) {
        Map<String, dynamic>? markers = userDoc['markers'];
        if (markers != null && markers.containsKey(markerId)) {
          return AlertDialog(
            title: Text('${markerData["origin"]} meal'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${markerData["type"]}'),
                Text('Amount: ${markerData["amount"]}'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () async {
                  final authState = Provider.of<AuthState>(
                      context, listen: false);
                  String user = authState.currentUser!.uid;
                  // Add confirmation logic here
                  // Update received field of current user

                  String compoundValue = markerData['uid'] + '_' + markerId;

                  await FirebaseFirestore.instance.collection('users')
                      .doc(user)
                      .update({
                    'received.$owner_uid': markerId,});
                  // delete that marker from og user
                  await FirebaseFirestore.instance.collection('users').doc(
                      owner_uid).update({
                    'runningFlags.$user': compoundValue,});
                  await FirebaseFirestore.instance.collection('users').doc(
                      owner_uid).update({
                    'markers.$markerId': FieldValue.delete(),},);
                  removeMarker(markerId);
                  print("This Just worked");

                  Navigator.of(context).pop();
                  //fetchData(); // to immediately refresh after a catch

                },
              ),
            ],
          );
        }
        else{
          // If the markerId doesn't exist in the markers map, show an error message
          return AlertDialog(
            title: Text('Oops you were late! '),
            content: Text('Someone caught the flag'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        }
      }else{
        // If user document doesn't exist or is not valid, show an error message
        return AlertDialog(
            title: Text('Error'),
            content: Text('User document not found or invalid.'),
            actions: <Widget>[
            TextButton(
            onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('OK'),
        )
        ]
        );
      }
      },
    );
  }


  //for own markers

  void _showSelfMarkerDialog(BuildContext context, String markerId, Map<String, dynamic> markerData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${markerData["origin"]} meal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${markerData["type"]}'),
              Text('Amount: ${markerData["amount"]}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                final authState = Provider.of<AuthState>(context, listen: false);
                String user = authState.currentUser!.uid;
                // Add Delete logic here
                // delete markers field of current user and marker doc

                await FirebaseFirestore.instance.collection('users').doc(userId).collection('markersDoc').doc(markerId).delete();

                await FirebaseFirestore.instance.collection('users').doc(userId).update({
                  'markers.$markerId': FieldValue.delete(),},);
                removeMarker(markerId); // remove from allmarkers

                print("This Just worked");

                Navigator.of(context).pop();
                fetchData();// to immediately refresh after the delete

              },
            ),
          ],
        );
      },
    );
  }


  void _default(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Found another flag in your caught flag status!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Claim the previous flag or delete it before catching another'),
            ],
          ),
        );
      },
    );
  }

  void removeMarker(String markerId) {
    if(mounted)
      {
        setState(() {
          allmarkers.removeWhere((marker) => marker.markerId.value == markerId);
        });
      }
  }

}
