import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viraj_application/home_screen.dart';
import 'package:viraj_application/onboarding.dart';
import 'package:viraj_application/signup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String mobileNumber = ''; // Declare instance variables here
  String isLoginFirst = '';

  @override
  void initState() {
    super.initState();
    // Simulate a delay for splash screen
    Future.delayed(Duration(seconds: 3), () {
      getValuesFromSharedPref();
    });
  }

  void getValuesFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString('mobileNumber') ?? '';
    isLoginFirst = prefs.getString('isloginfirst') ?? '';
    setState(() {}); // Trigger rebuild with new values
    movenext();
  }

  void movenext() {
    if (mobileNumber != "") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyDashboard(),
        ),
      );
    } else {
      if (isLoginFirst == "1") {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            // return SignUpPage();

            return Onboarding();
          },
        ));
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Onboarding(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'images/splashScreen.png', // Adjust path based on your image location
            fit: BoxFit.cover,
          ),
          // Center Logo Image
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo.png', // Adjust path based on your image location
                  width: 400, // Adjust width as needed
                  height: 400, // Adjust height as needed
                ),
                SizedBox(height: 20),
                // You can uncomment the CircularProgressIndicator if needed
                // CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
