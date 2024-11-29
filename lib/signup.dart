import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:viraj_application/signupotp.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  String errorMessage = "";
  bool validateMobileNumber = true;
  bool _isChecked = true;
  bool loading = true;

  @override
  void dispose() {
    super.dispose();
    validateMobileNumber = true;
    errorMessage = "";
    _mobileController.clear();
  }

  // Function to save user data in SharedPreferences
  Future<void> _saveUserData(String userId, String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('mobileNumber', mobileNumber);
  }

  // Function to make API call to get OTP
  void _getOTP() async {
    String mobileNumber = _mobileController.text.trim();
    String pushToken = "";

    if (mobileNumber.isEmpty) {
      setState(() {
        validateMobileNumber = false;
        errorMessage = "Mobile number cannot be empty";
      });
      return;
    }

    String apiUrl = "https://staginglink.org/twice/agent_login_api";
    Map<String, dynamic> body = {
      "mobile_number": mobileNumber,
      "push_token": pushToken,
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] != null &&
            jsonResponse['status'] is String) {
          bool status = jsonResponse['status'].toLowerCase() == 'true';

          if (status) {
            print("API Response: Success");

            // Save id and mobile_number in SharedPreferences
            String userId = jsonResponse['data'][0]['id'];
            String mobileNumber = jsonResponse['data'][0]['mobile_number'];
            await _saveUserData(userId, mobileNumber);

            // Show success Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("OTP sent successfully"),
                duration: Duration(seconds: 3),
              ),
            );

            // Navigate to OTP page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpOTPPage(),
              ),
            );
          } else {
            print("API Response: Failed");

            // Show failure Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Failed to send OTP: ${jsonResponse['message']}",
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          print("Invalid JSON response format or missing 'status' field.");
        }

        print("Full Response: ${response.body}");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception during API call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Your Safe Journey!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Create a new account',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 219, 213, 213).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  onChanged: (value) {
                    validateMobileNumber = true;
                    errorMessage = "";
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color.fromARGB(255, 240, 230, 230),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Icon(Icons.phone),
                      padding: EdgeInsets.only(left: 10, right: 10),
                    ),
                    hintText: 'Enter Your Mobile Number',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffB7B7B7)),
                    errorText: validateMobileNumber ? null : errorMessage,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 252, 250, 250)!),
                    ),
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'A 6 digit security code will be sent via SMS to verify your mobile number!',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.all(0.0),
                  width: 200.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFEC5012),
                        Color(0xFFD72B23),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: TextButton(
                    onPressed: _getOTP,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Get OTP',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}