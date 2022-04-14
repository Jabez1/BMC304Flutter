import 'package:flutter/material.dart';

//yes this is the default page lol
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {Navigator.pushNamed(context, '/loginPage');
                  },
                child: Icon(
                  Icons.login,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          // im kenji
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
                onPressed: () {Navigator.pushNamed(context, '/viewDeaths');}
            ),

            ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/viewClinic');},
                child: Text('View Clinic List'),
                style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                    padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                    textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            ),

            ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/casesCharts');},
                child: Text('View Case Charts'),
                style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                    padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),),

            ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/viewCovid');},
                child: Text('View Covid Cases'),
                style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                    padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),),

            ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/clinicMap');},
                child: Text('View Map'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom:10),
                  textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),),

          ],
        ),
      ),
    );
  }
}
