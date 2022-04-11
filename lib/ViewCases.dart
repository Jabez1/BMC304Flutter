import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ViewCases extends StatefulWidget {
  ViewCases({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ViewCases> {
  late Future <List<DeathCase>> futureDeathCase;

  @override
  void initState() {
    super.initState();
    futureDeathCase = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API and ListView Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter ListView'),
        ),
        body: Center(
          child: FutureBuilder <List<DeathCase>>(
            future: futureDeathCase,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DeathCase>? cases = snapshot.data;

                return
                  ListView.builder(
                      itemCount: cases?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = cases?[index];
                        return Dismissible(
                          key: Key(item!.getDeathDate()),

                          onDismissed: (direction){

                            setState((){
                              cases?.removeAt(index);
                              deleteDeathCase(item!.getDeathDate());
                            });
                          },
                          background:Container(color: Colors.red),
                          child: Center(
                              child: DeathCaseCard(
                                  date: cases![index].getDeathDate(),
                                  count: cases![index].deathCount
                              )
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

Future <List<DeathCase>> fetchData() async {
  final response =await http
      .get(Uri.parse('http://192.168.42.217/BMC304php/deathCaseJson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new DeathCase.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}

class DeathCase {
  final DateTime deathDate;
  final int deathCount;

  DeathCase({required this.deathDate, required this.deathCount});

  factory DeathCase.fromJson(Map<String, dynamic> json) {
    return DeathCase(
      deathDate: DateTime.parse(json['deathDate']),
      deathCount: int.parse(json['deathCount']),
    );
  }

  String getDeathDate(){
    return DateFormat('yyyy-MM-dd').format(this.deathDate);
  }
}

createDeathCase(String date, String count) async{
  final response = await http.post(
      Uri.parse('http://192.168.42.217/BMC304php/deathCaseInsert.php'),
      body:{
        'deathDate' : date,
        'deathCount' : count
      }
  );
  if (response.statusCode == 200){
    print("Returned Message: "+response.body.toString());
  }
  else{
    throw Exception('Unexpected Error Occurred!');
  }
}

deleteDeathCase(String date) async{
  final response = await http.post(
      Uri.parse('http://192.168.42.217/BMC304php/deathCaseDelete.php'),
      body:{
        'deathDate' : date
      }
  );
  if (response.statusCode == 200){
    print("Returned Message: "+response.body.toString());
  }
  else{
    throw Exception('Unexpected Error Occurred!');
  }
}

class DeathCaseCard extends StatelessWidget{
  const DeathCaseCard({Key? key, required this.date, required this.count});

  final String date;
  final int count;

  Widget build(BuildContext context){
    return Container(
        padding: EdgeInsets.all(5),
        height:200,
        width: 400,
        child: Card(
            child: InkWell(
                onTap: (){

                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:<Widget>[
                      Text(
                        "Date of Deaths: "+ this.date,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Death Count: " + this.count.toString()),

                    ]
                )
            )
        )
    );
  }
}