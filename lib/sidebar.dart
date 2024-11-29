import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viraj_application/signup.dart';

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

  @override
  Widget build(BuildContext context) {
    double width1 = MediaQuery.of(context).size.width * 0.2;
    double height1 = MediaQuery.of(context).size.height * 0.22;

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 103, 102, 101),
      width: 270,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/sidebar2.jpg"),
            fit: BoxFit.contain,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(top: height1),
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ApplyLeavePage()),
                // );
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
              imagePath: 'images/dispatch_icon.png', // Path to Dispatch image
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
              imagePath: 'images/settings_icon.png', // Path to Settings image
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
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    await pref.clear();
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
