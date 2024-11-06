import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addMarker({ required GeoPoint location, required String type, required String name, required String phone, required String origin, int amount = 0, String cause = 'Donation', String rest_id = 'NotRestaurant'}) async {
  try {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is signed in
    if (user != null) {
      // Get user UID
      String uid = user.uid;

      // Create marker document in marker sub-collection with auto-generated document ID
      CollectionReference markersCollectionRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('markersDoc');
      var markerDocRef = await markersCollectionRef.add({
        'restaurant_id': rest_id,
        'origin':origin,
        'location': location,
        'type': type,
        'name': name,
        'phone': phone,
        'amount': amount,
        'code': markersCollectionRef.doc().id,
        'uid':user.uid,
        'cause': cause,
      });
      String markerDocId = markerDocRef.id;

      await markerDocRef.update({'code': markerDocId});


      // Update user document with the marker title as the marker document ID
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'markers.$markerDocId': {
          'location': location,
          'type': type,
          'amount': amount,
          'origin': origin,
          'uid': uid,
          'cause': cause,
        },
      });

      // Increment the donated field in the user document using a transaction
      // await FirebaseFirestore.instance.runTransaction((transaction) async {
      //   DocumentSnapshot userDoc = await transaction.get(FirebaseFirestore.instance.collection('users').doc(uid));
      //   if (userDoc.exists) {
      //     int donated = userDoc['donated'] ?? 0;
      //     transaction.update(FirebaseFirestore.instance.collection('users').doc(uid), {'donated': donated + 1});
      //   }
      // });


    } else {
      print('User is not signed in.');
    }
  } catch (error) {
    print('Error adding marker: $error');
  }
}

Future<void> addRestaurantMarker({ required GeoPoint location, String type = 'prepaid', required String name, required String phone, String origin = 'restaurant', required int amount, required String cause, required String rest_id, required String creator_id })
async {
      //create a function
      //  ->to add this marker to users markerdoc.

  CollectionReference markersCollectionRef = FirebaseFirestore.instance.collection('users').doc(creator_id).collection('markersDoc');
  var markerDocRef = await markersCollectionRef.add({
    'restaurant_id': rest_id,
    'origin':origin,
    'location': location,
    'type': type,
    'name': name,
    'phone': phone,
    'amount': amount,
    'code': markersCollectionRef.doc().id,
    'uid': creator_id,
    'cause': cause,
  });
  String markerDocId = markerDocRef.id;

  await markerDocRef.update({'code': markerDocId});

  //  ->also add it to users marker collection.
  await FirebaseFirestore.instance.collection('users').doc(creator_id).update({
    'markers.$markerDocId': {
      'location': location,
      'type': type,
      'amount': amount,
      'origin': origin,
      'uid': creator_id,
      'restaurant_id':rest_id,
      'cause': cause,
    },
  });

      //add to restaurant UID->unverfiedMarkers
  await FirebaseFirestore.instance.collection('restaurants').doc(rest_id).update({
    'unverifiedMarkers.$markerDocId': {
      'creator': creator_id,
      'amount': amount,
      //'redeemer': redeemer_id,
    },
  });
      //add marker id and userID and redeemer_id to resturantUID-> records
  CollectionReference recordsCollectionRef = FirebaseFirestore.instance.collection('restaurants').doc(rest_id).collection('records');

  DocumentReference customerRecordDocRef = recordsCollectionRef.doc(creator_id);

  // Check if a document exists for this creator_id in records
   DocumentSnapshot customerRecordDoc = await customerRecordDocRef.get();

  if (customerRecordDoc.exists) {
    // Document exists, update it by appending the marker information
    print('Added to record to $creator_id marker $markerDocId');
    await customerRecordDocRef.update({
      'markers.$markerDocId': {
        'amount': amount,
        'creation_date': DateTime.now(),
        'receiver_id':'' //to be set later when a marker is redeemed
      },
    });
  } else {
    // Document does not exist, create it and add the marker information
    print('Created Record for $creator_id and added to $markerDocId to it');
    await customerRecordDocRef.set({
      'markers': {
        markerDocId: {
          'amount': amount,
          'creation_date': DateTime.now(),
          'receiver_id': ''
        },
      },
    });
  }

  print("Loooooooooooooooooooooooooook Here");
  print('${location}, ${type}, ${name}, ${phone}, ${origin}, $amount, $cause, $rest_id, $creator_id');
}
