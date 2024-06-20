import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Nosagences(),
    );
  }
}

class Nosagences extends StatefulWidget {
  @override
  State<Nosagences> createState() => MapSampleState();
}

class MapSampleState extends State<Nosagences> {
  static const LatLng _kTunisiaCenter = LatLng(34.8110, 10.7889);
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Markers on Map'),
      ),
      body: GoogleMap(
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
            target: _kTunisiaCenter,
            zoom: 7), // Default center of San Francisco
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addMarkerFromAddress('53 6000 Avenue Mongi Slim, Gabes');
          addMarkerFromAddress('V3MW+XXM, Gabès');
          addMarkerFromAddress('rue Tahar Battikh Houmt Souk, djerba 4180');
          addMarkerFromAddress('QQ66+9V, Sfax');
          addMarkerFromAddress('1 Apple Park Way, Cupertino, CA');
          addMarkerFromAddress('1 Apple Park Way, Cupertino, CA');
        },
        label: Text('Add Markers'),
        icon: Icon(Icons.add_location),
      ),
    );
  }

  Future<void> addMarkerFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(address),
              position: LatLng(locations[0].latitude, locations[0].longitude),
              infoWindow: InfoWindow(
                title: address,
                snippet: 'Marker placed here',
              ),
            ),
          );
        });
      }
    } catch (e) {
      print('Error adding marker: $e');
    }
  }
}
