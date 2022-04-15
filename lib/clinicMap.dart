import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '/ClinicFiles/Clinic.dart';
import 'main.dart';
import 'dart:convert';

void main() {
  runApp(const clinicMap());
}

Future <List<Clinic>> fetchData() async {
  final response =await http
      .get(Uri.parse('http://192.168.1.105:8080/convtjson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Clinic.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class clinicMap extends StatefulWidget {
  const clinicMap({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<clinicMap> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    List<Clinic> clinics = await fetchData();
    setState(() {
      //_markers.clear();
      for (final clinic in clinics) {
        final marker = Marker(
          markerId: MarkerId(clinic.centerId),
          position: LatLng(double.parse(clinic.vacLatitude),
                            double.parse(clinic.vacLongitude)),
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