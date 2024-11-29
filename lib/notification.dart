import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonDecode
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viraj_application/home_screen.dart'; // For SharedPreferences



// Define a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Assign the navigator key
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItemData> _allNotifications = [];
  List<NotificationItemData> _displayedNotifications = [];
  bool _isLoading = true;
  bool _hasMore = true; // Indicates if there are more items to load
  final int _initialLoadCount = 9; // Number of items to load initially
  int _currentLoadCount = 9; // Number of items currently loaded

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? employeeId = prefs.getString('id');
      if (employeeId == null) {
        print('No user ID found.');
        setState(() {
          _isLoading = false;
          _hasMore = false;
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
        print('Response data: $responseData');

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
          _allNotifications = notifications;
          _displayedNotifications =
              notifications.take(_initialLoadCount).toList();
          _isLoading = false;
          _hasMore = notifications.length > _initialLoadCount;
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
          _hasMore = false;
        });
        return;
      }

      print('Stack Trace: $stackTrace');
      print('Error parsing response: $e');
      print('Error fetching notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    return 'Just now'; // Replace this with actual date formatting logic
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _isLoading = true;
      _currentLoadCount = _initialLoadCount; // Reset to initial load count
      _displayedNotifications = [];
    });
    await _fetchNotifications();
  }

  void _loadMore() {
    setState(() {
      final remainingNotifications =
          _allNotifications.skip(_currentLoadCount).toList();
      final newLoadCount = _currentLoadCount + _initialLoadCount;
      _displayedNotifications.addAll(
        remainingNotifications.take(_initialLoadCount).toList(),
      );
      _currentLoadCount = newLoadCount;
      _hasMore = remainingNotifications.length > _initialLoadCount;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyDashboard()),
                );
                // Navigator.pop(context);
              },
            ),
            Text(
              'Notification',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading && _displayedNotifications.isEmpty
          ? _buildShimmer()
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: Scrollbar(
                thickness: 10.0, // Adjust the thickness of the scrollbar here
                radius: Radius.circular(
                    8.0), // Adjust the radius of the scrollbar thumb
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.0),
                  itemCount: _displayedNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = _displayedNotifications[index];
                    return NotificationItem(
                      message: notification.message,
                      timeAgo: notification.timeAgo,
                      icon: notification.icon,
                      appRedirectionUrl: notification.appRedirectionUrl,
                      recordId: notification.recordId,
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
            ),
            title: Container(
              color: Colors.grey[300],
              height: 16.0,
            ),
            subtitle: Container(
              color: Colors.grey[300],
              height: 14.0,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          ),
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String message;
  final String timeAgo;
  final IconData icon;
  final String appRedirectionUrl;
  final String recordId;

  NotificationItem({
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.appRedirectionUrl,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        message,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF424752),
        ),
      ),
      subtitle: Text(
        timeAgo,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC4C4C4),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      dense: true,
      onTap: () async {
        try {
          print('App Redirection URL: $appRedirectionUrl');
          print('Record ID: $recordId');

          final String landingPage = appRedirectionUrl
              .toLowerCase()
              .trim(); // Ensure consistent casing and trimming

          print('Landing page: $landingPage');

          Widget page;
          // switch (landingPage) {
          //   case 'all visits':
          //     page = AllVisits();
          //     break;
          //   case 'attendance':
          //     page = AttendencePage();
          //     break;
          //   case 'completed visits':
          //     page = CompletedVisits();
          //     break;
          //   case 'all tasks':
          //     page = YourTicketsPage();
          //     break;
          //   case 'completed tasks':
          //     page = YourCompletedTaskPage();
          //     break;
          //   case 'leave approved':
          //   case 'leave rejected':
          //     final SharedPreferences prefs =
          //         await SharedPreferences.getInstance();
          //     await prefs.setString('selected_leave_id', recordId);
          //     page = LeaveDetailsPage();
          //     break;
          //   case 'task assigned':
          //     final SharedPreferences prefs =
          //         await SharedPreferences.getInstance();
          //     await prefs.setString('taskId', recordId);
          //     page = YourTaskDetailsPage();
          //     break;
          //   case 'sitevisit detail':
          //     final SharedPreferences prefs =
          //         await SharedPreferences.getInstance();
          //     await prefs.setString('taskId', recordId);
          //     page = SiteVisitDetails();
          //     break;
          //   case 'pending visits':
          //     page = PendingVisits();
          //     break;
          //   default:
          //     page = NotificationPage();
          //     break;
          // }

          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) => page),
          // );
        } catch (e) {
          print('Error handling notification click: $e');
        }
      },
    );
  }
}

class NotificationItemData {
  final String message;
  final String timeAgo;
  final IconData icon;
  final String appRedirectionUrl;
  final String recordId;

  NotificationItemData({
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.appRedirectionUrl,
    required this.recordId,
  });
}
