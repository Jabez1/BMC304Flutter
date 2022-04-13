import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'HomePage.dart';
import 'ViewCases.dart';
import 'InsertCase.dart';
import 'CasesCharts.dart';
import 'UpdateCase.dart';
import 'AdminLoginPage.dart';

final String urIp = "192.168.42.217"; //Change ur IP here for easy php

void main() {
  runApp(const MyApp());
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
        '/viewCases': (context) => ViewCases(),
        '/insertCase': (context) => InsertCase(),
        '/casesCharts': (context) => CasesCharts(),
        '/updateCase': (context) => UpdateCase(),
        '/loginPage' : (context) => AdminLoginPage(),
      },
    );
  }
}

class Case{
  final DateTime deathDate;
  int deathCount;

  Case({required this.deathDate, required this.deathCount});

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      deathDate: DateTime.parse(json['deathDate']),
      deathCount: int.parse(json['deathCount']),
    );
  }

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
      deathDate: DateTime.parse(json['deathDate']),
      deathCount: int.parse(json['deathCount']),
    );
  }
}
