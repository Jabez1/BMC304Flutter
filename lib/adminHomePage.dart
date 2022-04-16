import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class adminHomePage extends StatefulWidget {
  const adminHomePage({Key? key}) : super(key: key);

  @override
  State<adminHomePage> createState() => _MyAdminHomePageState();
}

class _MyAdminHomePageState extends State<adminHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Home Page"),
          leading: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/');
            },
            child: Icon(Icons.arrow_back
            ),
          ),
        ),
        body: ButtonPage(),
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
            Bounceable(
              onTap: () {},
              scaleFactor: 0.6,
              child: ElevatedButton(
                child: Text('View Death Cases'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                    fixedSize: const Size(300, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    )),
                onPressed: () {Navigator.pushNamed(context, '/viewDeath');}
            )),

            Bounceable(
              onTap: () {},
              scaleFactor: 0.6,
              child: ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/viewClinic');},
              child: Text('View Clinic List'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.only(top: 5, right: 28, left: 28, bottom: 5),
                  fixedSize: const Size(300, 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            )),

            Bounceable(
              onTap: () {},
              scaleFactor: 0.6,
              child: ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/viewCovid');},
                  child: Text('Manage Covid Cases', textAlign: TextAlign.center),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 13, left: 13, bottom: 5),
                      fixedSize: const Size(300, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),)),

          ],
        )
      )
    );
  }
}


