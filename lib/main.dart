import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:io'; // Import for Platform class
import 'splash_screen.dart'; // Import the SplashScreen widget

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure the bindings are initialized
  await sendDeviceDetailsOnStartup();
  runApp(const MyApp());
}

Future<void> sendDeviceDetailsOnStartup() async {
  try {
    // Get device details
    Map<String, dynamic> deviceDetails = await getDeviceDetails();

    // Send device details without username and user ID
    await sendDeviceDetails(deviceDetails);
  } catch (e) {
    print("An error occurred while sending device details on startup: $e");
  }
}

Future<Map<String, dynamic>> getDeviceDetails() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceDetails = {};

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceDetails = {
      'device': androidInfo.model,
      'manufacturer': androidInfo.manufacturer,
      'android_version': androidInfo.version.release,
      'device_id': androidInfo.id, // Unique device ID
      'app_version':
          '0.0.4', // Update this to fetch the app version dynamically if needed
    };
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceDetails = {
      'device': iosInfo.utsname.machine,
      'manufacturer': 'Apple',
      'ios_version': iosInfo.systemVersion,
      'device_id': iosInfo.identifierForVendor, // Unique device ID
      'app_version':
          '0.0.4', // Update this to fetch the app version dynamically if needed
    };
  }

  return deviceDetails;
}

Future<void> sendDeviceDetails(Map<String, dynamic> deviceDetails) async {
  // Retrieve the mobile number from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? mobileNumber = prefs.getString('mobileNumber') ?? '';

  // URL of the API endpoint
  final url = 'https://staginglink.org/viraj_techplast/set_logged_in_user';

  // Prepare the request payload
  final requestPayload = {
    "project": "viraj",
    "device_id": deviceDetails['device_id'] ?? "",
    "device_details": json.encode(deviceDetails),
    "permission_details": json.encode([]), // Example, update as needed
    "mobile_no": mobileNumber, // Use the mobile number from SharedPreferences
    "name": "", // Add name if needed
  };

  try {
    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestPayload),
    );

    // Print the complete response body
    print("Response status: ${response.statusCode}");
    log("Response body of device details: ${response.body}");

    if (response.statusCode == 200) {
      // Parse the response if successful
      final responseData = json.decode(response.body);
      print("Response message: ${responseData['message']}");
    } else {
      print("Failed to send request. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }
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
