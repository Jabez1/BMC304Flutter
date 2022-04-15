import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'HomePage.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Icons.home,
      nextScreen: HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeft,
      backgroundColor: Colors.blue
    );
  }
}