import 'package:flutter/material.dart';
import 'package:assignment_clinic_finder/covidVideoPage.dart';
import 'package:assignment_clinic_finder/audioPage.dart';

//yes this is the default page lol
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.view_list_rounded)),
              Tab(icon: Icon(Icons.music_note_outlined)),
              Tab(icon: Icon(Icons.smart_display)),
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
          MyApp(),
          VideoPlayerApp(),
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
                      padding: EdgeInsets.only(top: 5, right: 67, left: 67, bottom:5),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),),
              ],
            )
        )
    );
  }
}

