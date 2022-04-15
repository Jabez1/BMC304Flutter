import 'package:flutter/material.dart';
import 'package:assignment_clinic_finder/covidVideoPage.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'common.dart';
import 'package:rxdart/rxdart.dart';


class adminHomePage extends StatefulWidget {
  const adminHomePage({Key? key}) : super(key: key);

  @override
  State<adminHomePage> createState() => _MyadminHomePageState();
}

class _MyadminHomePageState extends State<adminHomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Home Page"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.view_list_rounded)),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/loginPage');
                  },
                  child: Icon(
                    Icons.login,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: TabBarView(children: <Widget>[
          ButtonPage(),
        ],
        ),
      ),
    );
  }
}

class ButtonPage extends StatelessWidget{
  const ButtonPage({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //appBar: AppBar(
      //title: const Text('Home'),
      //),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                    child: Text('View Death Cases'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                        textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {Navigator.pushNamed(context, '/viewDeath');}
                ),

                ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/viewClinic');},
                  child: Text('View Clinic List'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 28, left: 28, bottom: 5),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),

                ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/casesCharts');},
                  child: Text('View Case Charts'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 5),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),),

                ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/viewCovid');},
                  child: Text('View Covid Cases'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 13, left: 13, bottom: 5),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),),

                ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/clinicMap');},
                  child: Text('View Map'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 67, left: 67, bottom:10),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),),
              ],
            )
        )
    );
  }
}


