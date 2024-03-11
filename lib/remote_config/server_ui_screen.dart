import 'package:firebase_services/remote_config/change_icon.dart';
import 'package:firebase_services/remote_config/dynamic_widgets.dart';
import 'package:firebase_services/remote_config/map_widgets.dart';
import 'package:firebase_services/remote_config/remote_config_services.dart';
import 'package:flutter/material.dart';

class RemoteConfigServerScreen extends StatefulWidget {
  const RemoteConfigServerScreen({super.key});

  @override
  State<RemoteConfigServerScreen> createState() => _RemoteConfigServerScreenState();
}

class _RemoteConfigServerScreenState extends State<RemoteConfigServerScreen> {
  final remoteConfig = FirebaseRemoteConfigService();
  List<Widget> serverWidgets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remoteConfig.initialize();
    getVal();
  }

  getVal() async {
    var serverJsonList = (await FirebaseRemoteConfigClass().initializeConfig());
    setState(() {
      serverWidgets = MapDataToWidget().mapWidgets(serverJsonList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        backgroundColor: Colors.white,
        title: const Text("Server Render UI",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/change_icon');
              },
              icon: Icon(Icons.settings_outlined,color: Colors.grey,)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ...serverWidgets,
            ],
          ),
          // child: Text(
          //   remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage),
          //   textAlign: TextAlign.center,
          // ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getVal();
          await remoteConfig.fetchAndActivate();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
