import 'dart:async';
import 'dart:convert';
import '/../main.dart';
import 'package:flutter/material.dart';
import 'package:assignment_clinic_finder/ClinicFiles/Clinic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:assignment_clinic_finder/ClinicFiles/AddClinicPage.dart';

Future <List<Clinic>> fetchData() async {
  final response =await http
      .get(Uri.parse('http://' + urIp + '/BMC304php/convtjson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Clinic.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
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
    Uri.parse('http://' + urIp + '/clinicDelete.php'),
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
          title: Text(AppLocalizations.of(context)!.viewCenter),
            leading: GestureDetector(
              onTap: () { Navigator.pushNamed(context, '/adminHomePage'); },
              child: Icon(
                Icons.arrow_back, // add custom icons also
              ),
            ),
            actions: <Widget> [Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {Navigator.pushNamed(context, '/addClinic');},
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),]
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
                            key: Key(item.getString()),
                            onDismissed:(direction){
                               if(direction == DismissDirection.endToStart){
                                setState(() {
                                  data?.removeAt(index);
                                  deleteClinic(item.getId());
                                });
                               }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content:
                              Text("$cenName" + AppLocalizations.of(context)!.dismiss)));
                            },
                          confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  if(direction == DismissDirection.endToStart){
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.confirmDelete),
                                      content: Text(AppLocalizations.of(context)!.questionDeleteCenter),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed:() => Navigator.of(context).pop(true),
                                          child: Text(AppLocalizations.of(context)!.delete)
                                        ),
                                        ElevatedButton(
                                            onPressed:() => Navigator.of(context).pop(false),
                                            child: Text(AppLocalizations.of(context)!.cancel),
                                        ),
                                      ],
                                    );
                                  }
                                  else{
                                    return AlertDialog (
                                      title: Text(AppLocalizations.of(context)!.confirmUpdate),
                                      content: Text(AppLocalizations.of(context)!.questionUpCenter),
                                      actions:<Widget>[
                                        ElevatedButton(
                                          onPressed: ()=> {
                                            Navigator.pushNamed(
                                                context,
                                                '/updateClinic',
                                                arguments: data?[index]
                                            )
                                          },
                                          child: Text(AppLocalizations.of(context)!.update)
                                        ),
                                        ElevatedButton(
                                            onPressed: ()=> Navigator.of(context).pop(false),
                                            child: Text(AppLocalizations.of(context)!.cancel),
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
                                vacAddress: data[index].vacAddress,
                                vacLad: data[index].vacLatitude,
                                vacLong: data[index].vacLongitude,
                                vacName : data[index].vaccineName,
                                amountLeft : data[index].amountLeft,
                                numPhone : data[index].numPhone),
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
                AppLocalizations.of(context)!.centerName +this.cenName,
                textAlign: TextAlign.center,
                style: TextStyle(
              fontWeight: FontWeight.bold
             )
            ),
            Text(AppLocalizations.of(context)!.address+":"+this.vacAddress, textAlign: TextAlign.left),
            Text(AppLocalizations.of(context)!.latitude+":" +this.vacLad,textAlign: TextAlign.left),
            Text(AppLocalizations.of(context)!.longitude+":" +this.vacLong,textAlign: TextAlign.left),
            Text(AppLocalizations.of(context)!.vaccineName+":" +this.vacName,textAlign: TextAlign.left),
            Text(AppLocalizations.of(context)!.amountLeft+":" +this.amountLeft,textAlign: TextAlign.left),
            Text(AppLocalizations.of(context)!.phone+":" +this.numPhone,textAlign: TextAlign.left),
            ],
          ),
        )
      )
    );
  }
}