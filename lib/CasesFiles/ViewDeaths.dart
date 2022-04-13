import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class ViewDeaths extends StatefulWidget {
  ViewDeaths({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ViewDeaths> {
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
          title: Text('List of Death Cases'),
          leading: GestureDetector(
            onTap: () { Navigator.pushNamed(context, '/'); },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
          actions: <Widget> [Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {Navigator.pushNamed(context, '/insertDeath');},
                child: Icon(
                    Icons.add,
                ),
              )
          ),]

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
                            if(direction == DismissDirection.startToEnd){
                              setState((){
                                cases?.removeAt(index);
                                deleteDeathCase(item.getDeathDate());
                              });
                            }
                          },
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                if(direction == DismissDirection.startToEnd){
                                  return AlertDialog(
                                    title: const Text("Delete Confirmation"),
                                    content: const Text("Are you sure you wish to delete this item?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("DELETE")
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("CANCEL"),
                                      ),
                                    ],
                                  );
                                }
                                else{
                                  return AlertDialog(
                                    title: const Text("Edit Confirmation"),
                                    content: const Text("Are you sure you wish to edit this item?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () => {
                                          Navigator.pushNamed(
                                              context,
                                              '/updateDeath',
                                              arguments: cases?[index]
                                          )
                                        },
                                        child: const Text("EDIT")
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("CANCEL"),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                          background:Container(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete_forever),
                          ),
                          secondaryBackground: Container(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            color: Colors.blue,
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.edit),
                          ),
                          child: Center(
                              child: DeathCaseCard(
                                  date: cases![index].getDeathDate(),
                                  count: cases[index].deathCount
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
      .get(Uri.parse('http://' + urIp + '/BMC304php/deathCaseJson.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new DeathCase.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}


deleteDeathCase(String date) async{
  final response = await http.post(
      Uri.parse('http://' + urIp + '/BMC304php/deathCaseDelete.php'),
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
        padding: EdgeInsets.all(2),
        height: 100,
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