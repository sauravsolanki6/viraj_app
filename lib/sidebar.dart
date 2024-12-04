import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viraj_application/production.dart';
import 'package:viraj_application/signup.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import 'dart:io'; // Import for Platform class

class SideBar extends StatefulWidget {
  const SideBar({Key? key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    super.initState();
    // Perform initialization if needed
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
    final url = 'https://staginglink.org/viraj_techplast/set_user_logout';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.2;
    double height1 = MediaQuery.of(context).size.height * 0.22;

    return Drawer(
      backgroundColor: Color(0xFFFFFFFF), // Use the color code for white
      width: 270, // Keep the fixed width for the drawer
      child: Container(
        width: double.infinity, // Ensure the container takes full width
        height: double.infinity, // Ensure the container takes full height
        child: Stack(
          children: [
            // Top image (sidebar.png) that appears only on the top 30px
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.1, // Adjust height based on screen height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                    fit: BoxFit
                        .cover, // Maintain aspect ratio while filling the space
                  ),
                ),
              ),
            ),
            // Main ListView that holds sidebar items
            ListView(
              padding: EdgeInsets.only(
                  top:
                      height1), // Adjust padding to avoid overlap with the image
              children: <Widget>[
                _buildSidebarItem(
                  imagePath: 'images/box6.png', // Path to the dashboard image
                  title: 'Dashboard',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ProfilePage()),
                    // );
                  },
                ),
                _buildSidebarItem(
                  imagePath:
                      'images/production_icon.png', // Path to the production image
                  title: 'Production',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductionPage()),
                    );
                  },
                ),
                _buildSidebarItem(
                  imagePath:
                      'images/qc_management_icon.png', // Path to QC Management image
                  title: 'QC Management',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LeavesList()),
                    // );
                  },
                ),
                _buildSidebarItem(
                  imagePath:
                      'images/ready_stock_icon.png', // Path to Ready Stock image
                  title: 'Ready Stock',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => TaskCreatePage()),
                    // );
                  },
                ),
                _buildSidebarItem(
                  imagePath:
                      'images/dispatch_icon.png', // Path to Dispatch image
                  title: 'Dispatch',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => NotificationPage()),
                    // );
                  },
                ),
                _buildSidebarItem(
                  imagePath: 'images/rework_icon.png', // Path to Rework image
                  title: 'Push For Rework',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => NotificationPage()),
                    // );
                  },
                ),
                _buildSidebarItem(
                  imagePath:
                      'images/settings_icon.png', // Path to Settings image
                  title: 'Settings',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => NotificationPage()),
                    // );
                  },
                ),
                _buildSidebarItem(
                  imagePath: 'images/logout_icon.png', // Path to Logout image
                  title: 'Logout',
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
      {required String imagePath,
      required String title,
      required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 24,
          height: 24,
          fit: BoxFit.cover, // Adjust image sizing as needed
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                ClipRect(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 86, 208, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300], // Horizontal gray line
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              // Use Expanded for Cancel button
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.resolveWith<
                                      BorderSide>(
                                    (Set<MaterialState> states) {
                                      return BorderSide(
                                          color:
                                              Colors.grey[300]!); // Gray border
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 50), // Adjust spacing between buttons
                            Expanded(
                              // Use Expanded for Yes, logout button
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFEC5012),
                                      Color(0xFFD72B23),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Map<String, dynamic> deviceDetails =
                                        await getDeviceDetails();

                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    await pref.clear();
                                    await sendDeviceDetails(deviceDetails);
                                    Navigator.pop(context);

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Yes, logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
            ),
          ),
        );
      },
    );
  }
}
