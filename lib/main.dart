// main.dart
import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the SplashScreen widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viraj App',
      theme: ThemeData(
        colorScheme: ColorScheme.light().copyWith(primary: Colors.orange),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
