import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viraj_application/signup.dart';

class OnboardingLast extends StatefulWidget {
  const OnboardingLast({Key? key}) : super(key: key);

  @override
  State<OnboardingLast> createState() => _OnboardingLastState();
}

class _OnboardingLastState extends State<OnboardingLast> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // savevaluetosharedpref();
  }

  // savevaluetosharedpref() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('isloginfirst', "1");
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/onboarding3.jpg'),
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
              subtitle: 'Start Managing Projects & HR Tasks Anytime, Anywhere',
              description:
                  'Access all your project details and HR tasks in one convenient app. Enjoy the flexibility to work efficiently from any location',
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
                // SizedBox(height: 25.0),
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
                SizedBox(height: 20.0),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 50.0),
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
                  ],
                ),
                SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          'Get Started',
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

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // Dispose the timer when the widget is disposed

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Login'),
//       // ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 'images/onboarding3.jpg'), // Replace 'path_to_your_background_image.png' with your image path
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: PageView(
//           controller: _pageController,
//           scrollDirection: Axis.horizontal,
//           onPageChanged: (int page) {
//             setState(() {
//               currentPage = page;
//             });
//           },
//           children: <Widget>[
//             _buildPage(
//               // imagePath: 'images/slider3.png',
//               title: '',
//               subtitle: 'Start Managing Projects & HR Tasks Anytime, Anywhere',
//               description:
//                   'Access all your project details and HR tasks in one convenient app. Enjoy the flexibility to work efficiently from any location',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPage({
//     // required String imagePath,
//     required String title,
//     required String subtitle,
//     required String description,
//   }) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           //   flex: 4,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 alignment: Alignment.bottomCenter,
//                 // child: Image.asset(
//                 //   imagePath,
//                 // ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           //  flex: 3,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 25.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               // borderRadius: BorderRadius.only(
//               //   topLeft: Radius.circular(75.0), // Adjust the radius as needed
//               //   topRight: Radius.circular(75.0), // Adjust the radius as needed
//               // ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 36.0,
//                     fontWeight: FontWeight.bold,
//                     foreground: Paint()
//                       ..shader = LinearGradient(
//                         colors: [Color(0xFFEC5012), Color(0xFFD72B23)],
//                         stops: [0.0, 1.0],
//                       ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: Color(0xFF000000),
//                     fontSize: 38.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 13.0,
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 8,
//                       height: 8,
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 8,
//                       height: 8,
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 8,
//                       height: 8,
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black, // Color of the circle
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 25.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.all(0.0),
//                       width: 200.0, // Adjusted width
//                       height: 50.0, // Adjusted height
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFFEC5012),
//                             Color(0xFFD72B23),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(32.0),
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SignUpPage(),
//                             ),
//                           );
//                         },
//                         style: TextButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(
//                               vertical: 15, horizontal: 20), // Text padding
//                           backgroundColor:
//                               Colors.transparent, // No background color
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: Text(
//                           'Get Started',
//                           style: TextStyle(
//                             fontFamily: 'Inter', // Font family
//                             fontSize: 18.0, // Font size
//                             fontWeight: FontWeight.w500, // Font weight
//                             height: 1.5, // Line height (24px)
//                             color: Colors.white, // Text color
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPageq({
//     required String imagePath,
//     required String title,
//     required String subtitle,
//     required String description,
//   }) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           flex: 5,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 alignment: Alignment.bottomCenter,
//                 //  padding: EdgeInsets.only(bottom: 0.0),
//                 child: Image.asset(
//                   imagePath,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           flex: 4,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 35.0),
//             //  margin: EdgeInsets.only(top: 60.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(75.0), // Adjust the radius as needed
//                 topRight: Radius.circular(75.0), // Adjust the radius as needed
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Color(0xFF0056D0),
//                     fontSize: 36.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: Color(0xFF0056D0),
//                     fontSize: 38.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 18.0,
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                 ),
//                 SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 200,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Navigator.pushReplacement(context, MaterialPageRoute(
//                           //   builder: (context) {
//                           //     return SignUpPage();
//                           //   },
//                           // ));
//                         },
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                             Color(0xFF0056D0),
//                           ),
//                         ),
//                         child: Text(
//                           'Get Started',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.0, // Set the font size
//                             fontWeight: FontWeight.bold, // Set the font weight
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
