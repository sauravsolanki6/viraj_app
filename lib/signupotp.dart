import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viraj_application/home_screen.dart';


class SignUpOTPPage extends StatefulWidget {
  @override
  _SignUpOTPPageState createState() => _SignUpOTPPageState();
}

class _SignUpOTPPageState extends State<SignUpOTPPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String _mobileNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchMobileNumber();
  }

  Future<void> _fetchMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mobileNumber = prefs.getString('mobileNumber') ?? '';
      print('Fetched mobile number: $_mobileNumber');
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _verifyOtp() async {
    for (var controller in _otpControllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP field is empty'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    String otp = _otpControllers.map((controller) => controller.text).join();

    var url =
        Uri.parse('https://staginglink.org/twice/validate_agent_login_otp_api');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mobile_number': _mobileNumber,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      bool status = false;
      if (responseData['status'] is bool) {
        status = responseData['status'];
      } else if (responseData['status'] is String) {
        status = responseData['status'].toLowerCase() == 'true';
      }

      if (status) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String empId = responseData['data'][0]['emp_id'];
        await prefs.setString('emp_id', empId);
        String id = responseData['data'][0]['id'];
        await prefs.setString('id', id);
        String name = responseData['data'][0]['first_name'];
        await prefs.setString('first_name', name);

        // Retrieve FCM token and send it to the server

        // OTP verified successfully, navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Verification failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to verify OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background images as overlays

          // Main content
          Positioned(
            top: height * 0.28,
            left: width * 0.070,
            child: Container(
              width: width * 0.4,
              height: height * 0.04,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  'Verify phone',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF353B43),
                    height: 1.2,
                    letterSpacing: 0.02,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.32,
            left: width * 0.11,
            child: Container(
              width: width * 0.7,
              height: height * 0.03,
              color: Colors.transparent,
              child: Text(
                'Please enter the 6 digit security code we just sent you at 222-444-XXXX',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: width * 0.032,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF353B43),
                  height: 1.2,
                ),
              ),
            ),
          ),
          // OTP container
          Positioned(
            top: height * 0.42,
            left: width * 0.11,
            child: Row(
              children: List.generate(
                6,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.012),
                  child: SizedBox(
                    width: width * 0.1,
                    height: width * 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          _onOtpChanged(index, value);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.52,
            left: width * 0.15, // Slightly shifted to the right
            child: GestureDetector(
              onTap: _verifyOtp,
              child: Container(
                width: width * 0.67,
                height: height * 0.06,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFEC5012), // start color
                      Color(0xFFD72B23), // end color
                    ],
                    stops: [0.0, 0.5661], // gradient stops
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: 0.02,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: height * 0.62,
            left: width * 0.36,
            child: Container(
              width: width * 0.29,
              height: height * 0.025,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  'Resend in 40 Sec',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0056D0),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.9,
            left: width * 0.23,
            child: Container(
              width: width * 0.5,
              height: height * 0.040,
              color: Colors.transparent,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Didn’t receive the code? ',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF353B43),
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0056D0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
