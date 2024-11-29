import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viraj_application/onboarding2.dart';
import 'package:viraj_application/signup.dart';


class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    savevaluetosharedpref();
  }

  savevaluetosharedpref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('isloginfirst', "1");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/onboarding1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int page) {},
          children: <Widget>[
            _buildPage(
              title: '',
              subtitle: 'Streamline Your Workflow On-the-Go',
              description:
                  'Effortlessly manage your design projects and HR tasks from your mobile device. Stay productive and organized no matter where you are.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 25.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Color(0xFFEC5012), Color(0xFFD72B23)],
                        stops: [0.0, 1.0],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black, // Color of the circle
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(0.0),
                      width: 150.0, // Adjusted width
                      height: 50.0, // Adjusted height
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEC5012),
                            Color(0xFFD72B23),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20), // Text padding
                          backgroundColor:
                              Colors.transparent, // No background color
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Inter', // Font family
                            fontSize: 18.0, // Font size
                            fontWeight: FontWeight.w500, // Font weight
                            height: 1.5, // Line height (24px)
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Spacer between buttons
                    Container(
                      margin: EdgeInsets.all(0.0),
                      width: 150.0, // Adjusted width
                      height: 50.0, // Adjusted height
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEC5012),
                            Color(0xFFD72B23),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          ); // Add your functionality for the second button here
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20), // Text padding
                          backgroundColor:
                              Colors.transparent, // No background color
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Inter', // Font family
                            fontSize: 18.0, // Font size
                            fontWeight: FontWeight.w500, // Font weight
                            height: 1.5, // Line height (24px)
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
