import 'package:flutter/material.dart';
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