import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '/ClinicFiles/Clinic.dart';
import 'main.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';

void main() {
  runApp(const clinicMap());
}

Future <List<Clinic>> fetchData() async {
  final response =await http
      .get(Uri.parse('http://' + urIp + '/convtjson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Clinic.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}

double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p)/2 +
      cos(lat1 * p) * cos(lat2 * p) *
          (1 - cos((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

class clinicMap extends StatefulWidget {
  const clinicMap({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<clinicMap> {
  final Map<String, Marker> _markers = {};
  late Future<List<Clinic>> futureClinics = fetchData();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    List<Clinic> clinics = await fetchData();

    setState(() {
      futureClinics = fetchData();
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
    return  DefaultTabController(
      length: 2,
      child: MaterialApp(
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
            bottom: TabBar(
                tabs:[
                  Tab(icon: Icon(Icons.edit)),
                  Tab(icon: Icon(Icons.edit)),
                ]
            )
          ),
          body:  TabBarView(
            //Disables the TabBar Swiping to not affect Map swiping
            physics: NeverScrollableScrollPhysics(),
            children : <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(3.1519, 101.6711),
                  zoom: 10,
                 ),
              markers: _markers.values.toSet(),
               ),
              FutureBuilder <List<Clinic>>(
                future: futureClinics,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Clinic>? data = snapshot.data;
                    //for each clinic, set the distance attribute using the calculateDistance method
                    data?.forEach((element) {
                      element.setDistance(calculateDistance(
                          3.1519, 101.6711,
                          double.parse(element.vacLatitude),
                          double.parse(element.vacLongitude)
                      ).toStringAsFixed(2)//rounds the result to 2 d.p and converts to String
                      );});
                    //Sort the list based on distance
                    data?.sort((a,b) =>
                        double.parse(a.distance as String).compareTo(
                            double.parse(b.distance as String)));
                    return
                      ListView.builder(
                        itemCount: data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: ClinicMapCard(cenName: data![index].centerName,
                                vacAddress: data[index].vacAddress,
                                vacLad: data[index].vacLatitude,
                                vacLong: data[index].vacLongitude,
                                vacName: data[index].vaccineName,
                                amountLeft: data[index].amountLeft,
                                numPhone: data[index].numPhone,
                                distance: data[index].distance as String
                            ),
                          );
                        },
                      );
                  }
                  return CircularProgressIndicator();
              }
            ),
           ],
         ),
        ),
      ),
    );
  }
}

class ClinicMapCard extends StatelessWidget{
  const ClinicMapCard({Key? key, required this.cenName, required this.vacAddress,
  required this.vacLad, required this.vacLong, required this.vacName,
  required this.amountLeft, required this.numPhone, required this.distance}) : super(key: key);
  final String cenName;
  final String vacAddress;
  final String vacLad;
  final String vacLong;
  final String vacName;
  final String amountLeft;
  final String numPhone;
  final String distance;

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(5),
      height: 200,
      width: 400,
      child: Card(
        child: InkWell(
          onTap: (){

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                  "Center Name: "+this.cenName, style: TextStyle(
                  fontWeight: FontWeight.bold
                  )
                ),
              Text("Address: "+this.vacAddress, textAlign: TextAlign.left),
              Text("Latitude: "+this.vacLad,textAlign: TextAlign.left),
              Text("Longitude: "+this.vacLong,textAlign: TextAlign.left),
              Text("Vaccine Name: "+this.vacName,textAlign: TextAlign.left),
              Text("Amount Left: "+this.amountLeft,textAlign: TextAlign.left),
              Text("Phone: "+this.numPhone,textAlign: TextAlign.left),
              Text("Distance: "+this.distance +"km away",textAlign: TextAlign.left),
            ],
          ),
        )
      )
    );
  }
}