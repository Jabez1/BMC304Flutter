import 'package:flutter/material.dart';
import 'package:assignment_clinic_finder/covidVideoPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context)!.appName),
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
                ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/casesCharts');},
                  child: Text(AppLocalizations.of(context)!.covidStats, textAlign: TextAlign.center),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 5),
                      fixedSize: const Size(300, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),),

                ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/clinicMap');},
                  child: Text(AppLocalizations.of(context)!.findClinic, textAlign: TextAlign.center),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.only(top: 5, right: 67, left: 67, bottom:5),
                      fixedSize: const Size(300, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),),
              ],
            )
        )
    );
  }
}

