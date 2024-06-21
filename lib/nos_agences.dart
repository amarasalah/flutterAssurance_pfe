import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
  Marker? _nearestMarker;

  // List of addresses to add markers from
  static const String initialAddress = "Assurances Maghrebia";
  static const List<String> addresses = [
    '${initialAddress} Kabaou Nouha Agency',
    '${initialAddress} Mchirgui Akrem Agency',
    '${initialAddress} agence Jomni',
    '${initialAddress} Abida Mohamed Agency',
    "${initialAddress} Boudaya Aymen Agency",
    "${initialAddress} Ellili Mohamed Agency",
    "${initialAddress} Agence Trabelsi Houda",
    "${initialAddress} Agence Hachicha Riadh",
    "${initialAddress} Agence Trigui Ines",
    "${initialAddress} Agence Kabaou Med Taher",
    "${initialAddress} Agence Sellami Abderrazak",
    "${initialAddress} Agence KAOUACH Amor",
    "${initialAddress} Agence Ennouri Hichem",
    "${initialAddress} Abbes Tarek Agency",
    "${initialAddress} Guen Kacem Agency",
    "${initialAddress} Mohamed Yasser Agency",
    "${initialAddress} M'Hamdi Yosri Agency",
    "${initialAddress} Agence Slama Abir",
    "${initialAddress} Sfar Ines Ep Kacem",
    "${initialAddress} Khadhraoui Othmen",
    "${initialAddress} Vie",
    "${initialAddress} Agence Berrabaa Nabil",
    "${initialAddress} Centre expertise MAGHREBIA",
    "JVVR+4JG, Ksar Hellal",
    "R6M4+5F9, Tunis",
    "QQ66+9V, Sfax",
    "64 Rue de La Palestine, Tunis 1002",
    "R6MR+VG4, Lac Albert, Tunis",
    "Av. de l'UMA, Tunis",
    "4 Rue Ibrahim Jaffel, Tunis",
  ];

  @override
  void initState() {
    super.initState();

    addMarkersFromAddresses();

    findNearestAgent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trouvez votre Agence'),
      ),
      body: GoogleMap(
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          if (_nearestMarker != null) {
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                _nearestMarker!.position,
                14.0,
              ),
            );
          }
        },
        initialCameraPosition: CameraPosition(
          target: _kTunisiaCenter,
          zoom: 7,
        ),
        mapType: MapType.terrain,
      ),
      floatingActionButton: _nearestMarker != null
          ? FloatingActionButton.extended(
              onPressed: () {
                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    _nearestMarker!.position,
                    14.0,
                  ),
                );
              },
              label: Text('Nearest Agent'),
              icon: Icon(Icons.place),
            )
          : null,
    );
  }

  Future<void> addMarkersFromAddresses() async {
    for (String address in addresses) {
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
                ),
              ),
            );
          });
        }
      } catch (e) {
        print('Error adding marker for $address: $e');
      }
    }
  }

  Future<void> findNearestAgent() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng userLocation = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      double minDistance = double.infinity;
      Marker? nearestMarker;

      for (Marker marker in _markers) {
        double distance = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestMarker = marker;
        }
      }

      setState(() {
        _nearestMarker = nearestMarker;
      });
    } catch (e) {
      print('Error finding nearest agent: $e');
    }
  }
}
