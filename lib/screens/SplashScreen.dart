import 'dart:async';
import 'package:firebase_services/authentication/welcome.dart';
import 'package:firebase_services/screens/RealTimeDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 3),
            ()=> Navigator.pushNamed(context, '/home')
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 200.0,
                  width: 200.0,
                ),
                const Text("Firebase Services",textAlign:TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
