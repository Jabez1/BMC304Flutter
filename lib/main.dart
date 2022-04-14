import 'package:assignment_clinic_finder/ClinicFiles/AddClinicPage.dart';
import 'package:assignment_clinic_finder/ClinicFiles/UpdateClinicPage.dart';
import 'package:assignment_clinic_finder/ClinicFiles/ViewClinic.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
//import 'ViewCases.dart';
//import 'InsertCase.dart';

final String urIp = "192.168.42.217"; //Change ur IP here for easy php

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
        //'/viewCases': (context) => ViewCases(),
        //'/insertCase': (context) => InsertCase(),
        '/viewClinic': (context) => ViewClinic(),
        '/addClinic': (context) => AddClinic(),
        '/updateClinic': (context) => UpdateClinic(),

      },
    );
  }
}