import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '/ClinicFiles/Clinic.dart';
import 'main.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(clinicMap());
}

Future <List<Clinic>> fetchData() async {
  final response =await http
      .get(Uri.parse('http://' + urIp + '/BMC304php/convtjson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Clinic.fromJson(data)).toList();
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
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<clinicMap> {
  final Map<String, Marker> _markers = {};
  final Map<PolylineId, Polyline> polylines ={};
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  double polyDistance =0.0;
  LatLng startLocation = LatLng(3.1775211976946025, 101.5489430677099);
  String googleApiKey = "AIzaSyAUVAWffRPafAJG9pyqfchp7qP-qtoQWzA";


  late Future<List<Clinic>> futureClinics = fetchData();
  Future<void> _onMapCreated(GoogleMapController controller) async {
    List<Clinic> clinics = await fetchData();

    setState(() {
      futureClinics = fetchData();
      mapController = controller;
      //_markers.clear();

      for (final clinic in clinics) {
        final marker = Marker(
          markerId: MarkerId(clinic.getId().toString()),
          position: LatLng(double.parse(clinic.getLatitude()),
                            double.parse(clinic.getLongitude())),
          infoWindow: InfoWindow(
            title:clinic.centerName,
            snippet: clinic.vacAddress,
          ),
        );
        _markers[clinic.centerName] = marker;
      }
    });
  }

  _getPolyline(Clinic end) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(startLocation.latitude, startLocation.longitude),
        PointLatLng(
          double.parse(end.vacLatitude),
          double.parse(end.vacLongitude),
        ),
        travelMode: TravelMode.driving,
        );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    double totalDistance = 0;
    for(var i = 0; i < polylineCoordinates.length-1; i++){
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i+1].latitude,
          polylineCoordinates[i+1].longitude);
    }
    setState(() {
      polyDistance = totalDistance;
    });
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 8,);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.findClinic),
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
                Tab(icon: Icon(Icons.map)),
                Tab(icon: Icon(Icons.list)),
              ]
          )
        ),
        body: FutureBuilder <List<Clinic>>(
          future: futureClinics,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Clinic>? data = snapshot.data;
              //for each clinic, set the distance attribute using the calculateDistance method
              data?.forEach((element) {
                element.setDistance(calculateDistance(
                    startLocation.latitude, startLocation.longitude,
                    double.parse(element.vacLatitude),
                    double.parse(element.vacLongitude)
                ).toStringAsFixed(2)//rounds the result to 2 d.p and converts to String
                );});
              //Sort the list based on distance
              data?.sort((a,b) =>
              double.parse(a.distance as String).compareTo(double.parse(b.distance as String)));
              _getPolyline(data![0]);
              return TabBarView(
                //Disables the TabBar Swiping to not affect Map swiping
                physics: NeverScrollableScrollPhysics(),
                children : <Widget>[
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: startLocation,
                      zoom: 15,
                   ),
                    markers: _markers.values.toSet(),
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                  AnimationLimiter(
                        child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ClinicMapCard(
                                    cenName: data[index].centerName,
                                    vacAddress: data[index].vacAddress,
                                    vacName: data[index].vaccineName,
                                    amountLeft: data[index].amountLeft,
                                    numPhone: data[index].numPhone,
                                    distance: data[index].distance as String
                                  ),
                              ),
                            ),
                          );
                        },
                      )
                  ),
                ]
              );
            }
                return CircularProgressIndicator();
            }
        ),
      ),
    );
  }
}

class ClinicMapCard extends StatelessWidget{
  ClinicMapCard({Key? key, required this.cenName, required this.vacAddress, required this.vacName,
  required this.amountLeft, required this.numPhone, required this.distance}) : super(key: key);
  final String cenName;
  final String vacAddress;
  final String vacName;
  final String amountLeft;
  final String numPhone;
  final String distance;

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(2),
      height: 180,
      width: 400,
      child: Card(
        child: InkWell(
          onTap: (){},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(this.cenName,
                  style: TextStyle(
                  fontWeight: FontWeight.bold
                  )
                ),
              Text(AppLocalizations.of(context)!.address+": "+this.vacAddress, textAlign: TextAlign.center),
              Text(AppLocalizations.of(context)!.vaccineName+": "+this.vacName,textAlign: TextAlign.left),
              Text(AppLocalizations.of(context)!.amountLeft+": "+this.amountLeft,textAlign: TextAlign.left),
              Text(AppLocalizations.of(context)!.phone+": " +this.numPhone,textAlign: TextAlign.left),
              Text(AppLocalizations.of(context)!.distance+": " +this.distance +"km",textAlign: TextAlign.left),
            ],
          ),
        )
      )
    );
  }
}
