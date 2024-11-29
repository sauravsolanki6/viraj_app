import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:viraj_application/notification.dart';
import 'package:viraj_application/sidebar.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  int _selectedIndex = 0;
  String _userData = ''; // State variable to hold user data
  late String _empId;
  late String id;
  late String name = 'Test'; // Direct initialization
  List<NotificationItemData> _notifications = [];
  bool _isLoading = true;
  // GlobalKey for RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int totalAllTask = 0;
  int totalCompletedTask = 0;
  int totalPendingTask = 0;
  int totalAllVisit = 0;
  int totalCompletedVisit = 0;
  int totalPendingVisit = 0;
  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget initializes
    _fetchUserData();
    getDataCount();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? employeeId = prefs.getString('id');
      if (employeeId == null) {
        print('No user ID found.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse(
            'https://staginglink.org/twice/get_employee_all_notification_api'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': employeeId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        final notifications = data.map((item) {
          return NotificationItemData(
            message: item['notification_description'] ?? '',
            timeAgo: _formatDate(item['created_on'] ?? ''),
            icon: Icons.notifications,
            appRedirectionUrl: item['app_redirection_url'] ?? '',
            recordId: item['record_id'] ?? '',
          );
        }).toList();

        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      } else {
        print(
            'Failed to load notifications. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      final prefs = await SharedPreferences.getInstance();
      final String? employeeId = prefs.getString('id');
      if (employeeId == null) {
        print('No user ID found.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('Error in fetchnotifications: $e');
      print('Stack Trace: $stackTrace');

      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    return 'Just now'; // Replace this with actual date formatting logic
  }

  Future<void> getDataCount() async {
    // Hardcoded employee_id
    // String employee_id = "2";
    final prefs = await SharedPreferences.getInstance();
    String empId = prefs.getString('id') ?? '';

    final url =
        Uri.parse('https://staginglink.org/twice/get_dashboard_count_api');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'employee_id': empId,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'true') {
          // Update state variables with fetched data
          setState(() {
            totalAllTask = responseData['data'][0]['total_all_task'];
            totalCompletedTask =
                responseData['data'][0]['total_completed_task'];
            totalPendingTask = responseData['data'][0]['total_pending_task'];
            totalAllVisit = responseData['data'][0]['total_assign_visit'];
            totalCompletedVisit =
                responseData['data'][0]['total_completed_visit'];
            totalPendingVisit = responseData['data'][0]['total_pending_visit'];
          });

          // Print for verification
          // print('Data Fetched successfully');
          // print('Total All Task: $totalAllTask');
          // print('Total Completed Task: $totalCompletedTask');
          // print('Total Pending Task: $totalPendingTask');
          // print('Data Fetched successfully');
          // print('Total All Visit: $totalAllVisit');
          // print('Total Completed Visit: $totalCompletedVisit');
          // print('Total Pending Visit: $totalPendingVisit');
        } else {
          print('Failed to fetch data: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error in getDataCount: $e');
      print('Stack Trace: $stackTrace');
      // Optionally, rethrow the exception or return an empty list
      throw Exception('Error during getDataCount API call: $e');
    }
  }

  void _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userData = prefs.getString('user_data') ?? '';
      _empId = prefs.getString('emp_id') ?? '';
      id = prefs.getString('id') ?? '';
      name = prefs.getString('first_name') ?? '';
    });

    // Check if all necessary data is available
    if (_userData.isNotEmpty &&
        _empId.isNotEmpty &&
        id.isNotEmpty &&
        name.isNotEmpty) {
      // Navigate to dashboard or perform auto-login logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyDashboard()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        // No need to navigate to the same page
        break;
      case 1:
        _navigateToAttendanceManagement();
        break;
      case 2:
        _navigateToTaskList();
        break;
      case 3:
        _navigateToProfile();
        break;
      // Add cases for other bottom navigation items as needed
    }
  }

  void _navigateToAttendanceManagement() {
    // Navigate to Attendance Management page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => AttendencePage()),
    // );
  }

  void _navigateToProfile() {
    // Navigate to Profile page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProfilePage()),
    // );
  }

  void _navigateToTaskList() {
    // Navigate to Profile page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => YourTicketsPage()),
    // );
  }

  void _navigateToLEaveManagement() {
    // Navigate to Leave Management page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ApplyLeavePage()),
    // );
  }

  void _navigateToTaskManagement() {
    // Navigate to Leave Management page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TaskCreatePage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        // Navigate back to sign-up page if current page is homepage
        if (_selectedIndex == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyDashboard()),
          );
          return true; // Allow exiting the app
        } else {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Prevent exiting the app
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEC5012),
        appBar: AppBar(
          toolbarHeight: 90.0,
          backgroundColor: const Color(0xFFEC5012),
          automaticallyImplyLeading: false,
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 233, 205, 205)),
          title: const Text(
            'Viraj Techplast',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        endDrawer: const SideBar(),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          backgroundColor: Colors.white,
          color: const Color(0xFFE03A1D),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: const Color(0xFFEC5012),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            "Hi, $name 🙋‍♂️ ",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add other widgets if needed
                ],
              ),
              const SizedBox(height: 10.0),
              firstCardWidget(),
              const SizedBox(height: 30.0),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        taskMonitoringContainer(context),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Notifications',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.notifications_active_outlined,
                                color: Color(0xFFEC5012),
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator() // Show a loading indicator while fetching
                            : _notifications.isEmpty
                                ? const Center(
                                    child: Text('No notifications available.'))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    shrinkWrap:
                                        true, // Use to prevent constraints issue in Column
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Disable scrolling within Column
                                    itemCount: _notifications.length > 6
                                        ? 6
                                        : _notifications.length, // Limit to 6
                                    itemBuilder: (context, index) {
                                      final notification =
                                          _notifications[index];
                                      return NotificationItem(
                                        message: notification.message,
                                        timeAgo: notification.timeAgo,
                                        icon: notification.icon,
                                        appRedirectionUrl:
                                            notification.appRedirectionUrl,
                                        recordId: notification.recordId,
                                      );
                                    },
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFFE03A1D),
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.assignment_ind_outlined),
            //   label: 'Attendance',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.speaker_notes_outlined),
            //   label: 'Task',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }

  Widget firstCardWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        firstCardInsideCardWidget('Running Batches', 0),
        firstCardInsideCardWidget('Pending Order', 1),
        firstCardInsideCardWidget('Completed Order', 2),
      ],
    );
  }

  Widget firstCardInsideCardWidget(String name, int index) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            _navigateToAttendanceManagement();
            break;
          case 1:
            _navigateToTaskManagement();
            break;
          case 2:
            _navigateToLEaveManagement();
            break;
          // Add cases for other cards as needed
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.width * 0.25,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF3C7B4).withOpacity(0.30),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Remove the image here
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget taskMonitoringContainer(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9, // 90% of the screen width
      height: screenHeight * 0.43, // 43% of the screen height
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(
          25), // Add padding here for spacing from outer box
      decoration: BoxDecoration(
        color: const Color(0xFFF3C7B4).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two boxes in a row
          crossAxisSpacing: 12, // Smaller space between boxes
          mainAxisSpacing: 12, // Smaller space between rows
          childAspectRatio: 1, // Keeps boxes square-shaped
        ),
        padding:
            const EdgeInsets.all(0), // No padding needed for GridView itself
        itemCount: 4,
        itemBuilder: (context, index) {
          List<String> titles = [
            'Dashboard',
            'Production',
            'Ready Stock',
            'Dispatch'
          ];
          List<String> images = [
            'box1.png',
            'box2.png',
            'box3.png',
            'box4.png'
          ];

          return GestureDetector(
            onTap: () {
              // Add navigation or action here
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFCC332B),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/${images[index]}',
                    width: screenWidth * 0.12, // Smaller image size
                    height: screenWidth * 0.12, // Smaller image size
                  ),
                  const SizedBox(height: 15),
                  Text(
                    titles[index],
                    style: GoogleFonts.inter(
                      fontSize: 15, // Smaller font size
                      fontWeight: FontWeight.w600,
                      height: 15.73 / 12, // Adjust line height for smaller font
                      letterSpacing: 0.02,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _fetchUserData();
    getDataCount();
    // Implement your refresh logic here, such as fetching new data
    // You can also reset variables or states as needed
    await Future.delayed(const Duration(seconds: 1)); // Simulating a delay

    setState(() {
      // Update state variables if necessary
    });
  }
}
