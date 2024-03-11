import 'package:flutter/material.dart';

import '../authentication/welcome.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static String id = 'home_screen';

  // Define a list of services with corresponding icons
  final List<Map<String, dynamic>> services = [
    {"name": "Cloud Firestore", "icon": Icons.cloud},
    {"name": "Real-Time Database", "icon": Icons.data_usage},
    {"name": "Authentication", "icon": Icons.lock},
    {"name": "Cloud Messaging", "icon": Icons.message},
    {"name": "Cloud Storage", "icon": Icons.cloud_upload},
    {"name": "Remote Config", "icon": Icons.settings_remote},
    {"name": "Cloud Functions", "icon": Icons.settings_ethernet},
    {"name": "Hosting", "icon": Icons.public},
    {"name": "Firebase ML (Machine Learning)", "icon": Icons.analytics},
    {"name": "App Check", "icon": Icons.verified_user},
    {"name": "Firebase Extensions", "icon": Icons.extension},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, color: Colors.black,),
        toolbarHeight: 65,
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('Home Screen', style: TextStyle(
          color: Colors.black
        ),),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          itemCount: services.length,
          itemBuilder: (BuildContext context, int index) {
            final service = services[index];
            return GestureDetector(
              onTap: () {
                // Handle item click
                if(index == 1){
                  Navigator.pushNamed(context, "/realtime");
                }else if(index == 2){
                  Navigator.popAndPushNamed(context, WelcomeScreen.id);
                }else if(index == 4){
                  Navigator.pushNamed(context, "/storage");
                }else if(index == 5){
                  Navigator.pushNamed(context, "/remote");
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Clicked: ${service["name"]}'),
                  ),
                );
                }
              },
              child: Card(
                elevation: 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(service["icon"], size: 40),
                     const SizedBox(height: 10),
                     Text(service["name"], textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
