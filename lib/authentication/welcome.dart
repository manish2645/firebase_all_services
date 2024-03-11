import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/authentication/phone_number.dart';
import 'package:firebase_services/authentication/signup.dart';
import 'package:firebase_services/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'components/components.dart';
import 'login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _saving,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TopScreenImage(screenImageName: 'home.jpg'),
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const ScreenTitle(title: 'Hello'),
                        const Text(
                          'Welcome to Firebase Services',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Hero(
                          tag: 'login_btn',
                          child: CustomButton(
                            buttonText: 'Login',
                            onPressed: () {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Hero(
                          tag: 'signup_btn',
                          child: CustomButton(
                            buttonText: 'Sign Up',
                            isOutlined: true,
                            onPressed: () {
                              Navigator.pushNamed(context, SignUpScreen.id);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Hero(
                        //   tag: 'phone_number',
                        //   child: CustomButton(
                        //     buttonText: 'Phone Number Signup',
                        //     isOutlined: true,
                        //     onPressed: () {
                        //       Navigator.pushNamed(context,PhoneAuthForm.id);
                        //     },
                        //   ),
                        // ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Sign up using',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {

                              },
                              icon: CircleAvatar(
                                radius: 25,
                                child: Image.asset(
                                    'assets/images/icons/facebook.png'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _saving = true;
                                });
                                signInWithGoogle().then((value) =>
                                    Navigator.pushNamed(context, HomeScreen.id)
                                );
                              },
                              icon: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child:
                                Image.asset('assets/images/icons/google.png'),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 25,
                                child: Image.asset(
                                    'assets/images/icons/linkedin.png'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    if(credential!=null){
      setState(() {
        _saving = false;
      });
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

}