import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _TKM = LatLng(8.914490072226974, 76.63191990838413);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 55, 149, 112),
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu_rounded, size: 37)),
        actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search, size: 37,))],

      ),

      body: const GoogleMap(initialCameraPosition: CameraPosition(target: _TKM, zoom: 13))
    );
  }
}
