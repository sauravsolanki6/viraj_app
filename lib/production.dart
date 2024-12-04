import 'package:flutter/material.dart';
import 'package:shimmer/main.dart';
import 'package:viraj_application/generate_order_list.dart';
import 'package:viraj_application/generateorder.dart';
import 'package:viraj_application/home_screen.dart';

class ProductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate box sizes dynamically
    final boxWidth = screenWidth * 0.42; // 40% of screen width
    final boxHeight = screenHeight * 0.2; // 20% of screen height
    final gap = screenWidth * 0.05; // 5% of screen width for gaps

    return WillPopScope(
      onWillPop: () async {
        // Navigate to SDateTime when back button is pressed
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyDashboard(),
          ),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Production',
            style:
                TextStyle(color: Colors.white), // Set the text color to white
          ),
          backgroundColor: Color(0xFFCC332B), // Set the background color
          foregroundColor: Colors.white, // Ensure icons and text are white
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyDashboard(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for the two boxes at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Box 1
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => GenerateOrderPage(),
                    //     ),
                    //   );
                    // },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: boxWidth,
                      height: boxHeight,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Generate Order',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: gap), // Dynamic gap
                  // Box 2
                  Container(
                    width: boxWidth,
                    height: boxHeight,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Job Card',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap), // Dynamic space between rows
              // Box 3
              Container(
                width: boxWidth,
                height: boxHeight,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Batch Processing',
                    style: TextStyle(color: Colors.black, fontSize: 18),
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
