import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import '/../main.dart';

void main() {
  runApp(const clinicMap());
}

class clinicMap extends StatefulWidget {
  const clinicMap({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<clinicMap> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final vacClinics = await locations.getClinics();
    setState(() {
      //_markers.clear();
      for (final clinic in vacClinics.clinics) {
        final marker = Marker(
          markerId: MarkerId(clinic.centerId),
          position: LatLng(clinic.vacLatitude, clinic.vacLongitude),
          infoWindow: InfoWindow(
            title:clinic.centerName,
            snippet: clinic.vacAddress,
          ),
        );
        _markers[clinic.centerName] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Vaccination Center'),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back
            ),
          ),
          backgroundColor: Colors.lightBlue[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(3.1519, 101.6711),
            zoom: 10,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}