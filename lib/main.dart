import 'package:assignment_clinic_finder/ClinicFiles/AddClinicPage.dart';
import 'package:assignment_clinic_finder/ClinicFiles/UpdateClinicPage.dart';
import 'package:assignment_clinic_finder/ClinicFiles/ViewClinic.dart';
import 'package:assignment_clinic_finder/covidVideoPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'HomePage.dart';
import 'CasesFiles/ViewDeaths.dart';
import 'CasesFiles/ViewCovid.dart';
import 'CasesFiles/InsertDeath.dart';
import 'CasesFiles/InsertCovid.dart';
import 'CasesFiles/CasesCharts.dart';
import 'CasesFiles/UpdateDeath.dart';
import 'CasesFiles/UpdateCovid.dart';
import 'AdminLoginPage.dart';
import 'clinicMap.dart';

final String urIp = "192.168.1.105:8080"; //Change ur IP here for easy php

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/viewDeath': (context) => ViewDeaths(),
        '/insertDeath': (context) => InsertDeath(),
        '/updateDeath': (context) => UpdateDeath(),

        '/viewCovid': (context) => ViewCovid(),
        '/insertCovid': (context) => InsertCovid(),
        '/updateCovid': (context) => UpdateCovid(),

        '/casesCharts': (context) => CasesCharts(),
        '/loginPage' : (context) => AdminLoginPage(),
        '/clinicMap' : (context) => clinicMap(),
        '/viewClinic': (context) => ViewClinic(),
        '/addClinic': (context) => AddClinic(),
        '/updateClinic': (context) => UpdateClinic(),

        '/videoPage': (context) => VideoPlayerApp(),

      },
    );
  }
}

class Case{
  final DateTime deathDate;
  int deathCount;

  Case({required this.deathDate, required this.deathCount});

  String getDeathDate(){
    return DateFormat('yyyy-MM-dd').format(this.deathDate);
  }
}
class DeathCase extends Case {
  DeathCase({ required DateTime deathDate, required int deathCount})
      : super(deathDate:deathDate, deathCount: deathCount);

  factory DeathCase.fromJson(Map<String, dynamic> json) {
    return DeathCase(
      deathDate: DateTime.parse(json['deathDate']),
      deathCount: int.parse(json['deathCount']),
    );
  }
}

class CovidCase extends Case {
  CovidCase({ required DateTime deathDate, required int deathCount})
      : super(deathDate: deathDate, deathCount: deathCount);

  factory CovidCase.fromJson(Map<String, dynamic> json) {
    return CovidCase(
      deathDate: DateTime.parse(json['covidDate']),
      deathCount: int.parse(json['covidCount']),
    );
  }
}
