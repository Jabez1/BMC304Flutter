import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String getString()
  {
    return (this.centerName);
  }

  String getId()
  {
    return this.centerId;
  }

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

void main() => runApp(ViewClinic());

class ViewClinic extends StatefulWidget {
  ViewClinic({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

deleteClinic(String cenID) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.105:8080/clinicDelete.php'),
    body: {
      'centerId':cenID
    }
  );

  if (response.statusCode == 200) {
    print("Returned message: "+ response.body.toString());
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class _MyAppState extends State<ViewClinic> {
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
                        final item = data?[index];
                        final cenName = item!.getString();
                        return Dismissible(
                            key: Key(item!.getString()),
                            onDismissed:(direction){
                               if(direction == DismissDirection.endToStart){
                                setState(() {
                                  data?.removeAt(index);
                                  deleteClinic(item!.getId());
                                });
                               }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content:
                              Text('$cenName had been dismissed')));
                            },
                          confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  if(direction == DismissDirection.endToStart){
                                    return AlertDialog(
                                      title: const Text("Delete Confirmation"),
                                      content: const Text("Are you sure you wish to delete this center info ?"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed:() => Navigator.of(context).pop(true),
                                          child: const Text("Delete")
                                        ),
                                        ElevatedButton(
                                            onPressed:() => Navigator.of(context).pop(false),
                                            child: const Text("Cancel"),
                                        ),
                                      ],
                                    );
                                  }
                                  else{
                                    return AlertDialog (
                                      title: const Text("Update Confirmation"),
                                      content: const Text("Are you sure you wish to update this center info ?"),
                                      actions:<Widget>[
                                        ElevatedButton(
                                          onPressed: ()=> {
                                            Navigator.pushNamed(
                                              context,
                                              '/updateClinic',
                                              arguments: data?[index]
                                            )
                                          },
                                          child: const Text("Update")
                                        ),
                                        ElevatedButton(
                                            onPressed: ()=> Navigator.of(context).pop(false),
                                            child: const Text("Cancel"),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              );
                          },

                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.edit),
                          ),
                          secondaryBackground:Container(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete_forever_outlined),
                          ),
                          child: Center(
                            child: ClinicCard(cenName: data![index].centerName,
                                vacAddress: data![index].vacAddress,
                                vacLad: data![index].vacLatitude,
                                vacLong: data![index].vacLongitude,
                                vacName : data![index].vaccineName,
                                amountLeft : data![index].amountLeft,
                                numPhone : data![index].numPhone),
                          ),
                        );
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

class ClinicCard extends StatelessWidget{
  const ClinicCard({Key? key, required this.cenName, required this.vacAddress,
    required this.vacLad, required this.vacLong, required this.vacName,
    required this.amountLeft, required this.numPhone}) : super(key: key);
  final String cenName;
  final String vacAddress;
  final String vacLad;
  final String vacLong;
  final String vacName;
  final String amountLeft;
  final String numPhone;

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(5),
      height: 200,
      width: 400,
      child: Card(
          child: new InkWell(
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
            ],
          ),
        )
      )
    );
  }
}