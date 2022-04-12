import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future <List<Clinic>> fetchData() async {
  final response =await http
      .get(Uri.parse('https://192.168.1.105/convtjson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Clinic.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Clinic {
  final String centerId;
  final String centerName;
  final String vacAddress;
  final String vacLatitude;
  final String vacLongitude;
  final String vaccineName;
  final String amountLeft;
  final String numPhone;


  Clinic({required this.centerId, required this.centerName,
    required this.vacAddress,required this.vacLatitude ,
    required this.vacLongitude, required this.vaccineName,
    required this.amountLeft, required this.numPhone});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      centerId: json['center_id'],
      centerName: json['center_name'],
      vacAddress: json['address'],
      vacLatitude: json['latitude'],
      vacLongitude: json['longitude'],
      vaccineName: json['vaccine_name'],
      amountLeft: json['amount_left'],
      numPhone: json['phone'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future <List<Clinic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaccination Center List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vaccination Center ListView'),
        ),
        body: Center(
          child: FutureBuilder <List<Clinic>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Clinic>? data = snapshot.data;

                return
                  ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 75,
                          color: Colors.white,
                          child: Center(child: Text(data![index].centerName),
                          ),);
                      }
                  );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}