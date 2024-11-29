import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viraj_application/onboardinglast.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/onboarding2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int page) {},
          children: <Widget>[
            _buildPage(
              // imagePath: 'images/slider2.png',
              title: '',
              subtitle: 'Begin Your Mobile Journey with Viraj',
              description:
                  'Experience seamless design and HR management right at your fingertips.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    // required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Move content to the top
      children: <Widget>[
        Expanded(
          //   flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                // child: Image.asset(
                //   imagePath,
                // ),
              ),
            ],
          ),
        ),
        Expanded(
          //  flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(75.0),
              //   topRight: Radius.circular(75.0),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                    fontSize: 13.0,
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                  ],
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(0.0),
                      width: 200.0, // Adjusted width
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
                              builder: (context) => OnboardingLast(),
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
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         Navigator.pushReplacement(context, MaterialPageRoute(
                //           builder: (context) {
                //             return MyDashboard();
                //           },
                //         ));
                //       },
                //       child: Text(
                //         'Skip',
                //         style: TextStyle(
                //             color: colorfile().buttoncolor,
                //             fontSize: 16,
                //             fontWeight: FontWeight.w600),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage1({
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Column(
      children: <Widget>[
        Expanded(
          // flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  imagePath,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          //flex: 4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75.0),
                topRight: Radius.circular(75.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF0056D0),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF0056D0),
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingLast(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFF0056D0),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pushReplacement(context, MaterialPageRoute(
                        //   builder: (context) {
                        //     return SignUpPage();
                        //   },
                        // ));
                      },
                      // child: Text(
                      //   'Skip',
                      //   style: TextStyle(
                      //       color: colorfile().buttoncolor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600),
                      // ),
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
