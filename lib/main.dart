import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_services/authentication/phone_number.dart';
import 'package:firebase_services/remote_config/change_icon.dart';
import 'package:firebase_services/remote_config/server_ui_screen.dart';
import 'package:firebase_services/screens/HomeScreen.dart';
import 'package:firebase_services/screens/RealTimeDatabase.dart';
import 'package:firebase_services/screens/SplashScreen.dart';
import 'package:firebase_services/storage/CloudStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'authentication/welcome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool updateRequired = false;

  Future<bool> isUpdateRequired() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    updateRequired = remoteConfig.getBool('force_update');
    int currentVersion = remoteConfig.getInt('current_version');
    print("current: ${remoteConfig.getString('current_version')}");
    int appVersion = remoteConfig.getInt('app_version');
    print("App Version is: $appVersion");
    print("Current Version is: $currentVersion");
    print("update bool value: $updateRequired");
    print(updateRequired && currentVersion.compareTo(appVersion) != 0 );
    return updateRequired && currentVersion.compareTo(appVersion) != 0 ;
  }

  Future<void> setupRemoteConfig() async {

    //final RemoteConfig remoteConfig = RemoteConfig.instance;
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ));

    await remoteConfig.fetchAndActivate();
  }

  @override
  void initState() {
    super.initState();
    setupRemoteConfig().then((value) async =>
    updateRequired = await isUpdateRequired());
    print('updateRequired$updateRequired');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("update$updateRequired");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Services',
      theme: ThemeData(
          backgroundColor: const Color(0xFFFF800B),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Ubuntu',
            ),
          )),
      initialRoute: "/",
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => updateRequired ? const UpdateScreen() : HomeScreen(),
        '/realtime':(context) => const RealTimeDatabase(),
        '/storage':(context) => const CloudStorage(),
        '/remote':(context) => const RemoteConfigServerScreen(),
        '/change_icon':(context) => const ChangeIcon(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        HomeScreen.id:(context) => HomeScreen(),
        PhoneAuthForm.id:(context) => PhoneAuthForm(),
      },
    );
  }
}

class UpdateScreen extends StatelessWidget {

  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.appname.application&pli=1';

  const UpdateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Required'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Update the app to continue using it.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              child: const Text('Update Now'),
              onPressed: () {
                // Redirect user to the app store for update
                _launchURL(PLAY_STORE_URL);
              },
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
      throw 'Could not launch $url';
  }
}