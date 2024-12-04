import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:viraj_application/generateorder.dart';
import 'package:viraj_application/production.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<List<GenerateOrder>>? ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = fetchOrders();
  }

  Future<List<GenerateOrder>> fetchOrders() async {
    final url = Uri.parse(
        'https://staginglink.org/viraj_techplast/get_generate_order_data');
    final response = await http.post(url);

    // Print the raw response body for debugging
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      print('Decoded JSON Data: $jsonData');

      if (jsonData['status'] == "true") {
        List<dynamic> data = jsonData['data'];
        print('Data array: $data');

        if (data.isEmpty) {
          throw Exception('No data available in the response');
        }

        return data.map((order) => GenerateOrder.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load orders, status is not "true"');
      }
    } else {
      throw Exception(
          'Failed to connect to API, status code: ${response.statusCode}');
    }
  }

  Future<void> _refreshOrders() async {
    setState(() {
      ordersFuture = fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Navigate to SDateTime when back button is pressed
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductionPage(),
          ),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Orders',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),

          backgroundColor: Color(0xFFCC332B),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductionPage(),
                ),
              );
            },
          ),
          elevation: 1,
          centerTitle: false, // Aligns title to the left
          foregroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 8.0), // Add some space between button and edge
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateOrderPage(),
                    ),
                  );
                  // Code to navigate to generate order screen or show dialog
                  print('Generate Order button pressed');
                  // Navigate to generate order screen if needed
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateOrderScreen()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFFCC332B),
                  backgroundColor: Colors.white, // Text color
                  elevation:
                      0, // Remove the elevation if you want a flat button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Makes the button rounded
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6), // Small padding
                ),
                child: Text(
                  'Generate Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshOrders,
          child: FutureBuilder<List<GenerateOrder>>(
            future: ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSkeleton(screenWidth, screenHeight);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No orders available.',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                final orders = snapshot.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: screenWidth * 0.04,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Color(0xFFCC332B), width: 2),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ID: ${order.orderId}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.black,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    order.status == '1' ? 'Active' : 'Inactive',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: order.status == '1'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Product: ${order.productName}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Amount: ₹${order.orderAmount}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Date: ${order.orderDate}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Client: ${order.clientName}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Branch: ${order.branchName}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date & Time: ${order.createdOn}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton(double screenWidth, double screenHeight) {
    return ListView.builder(
      itemCount: 5, // You can change this to adjust the number of skeletons
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: screenWidth * 0.04,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Color(0xFFCC332B), width: 2),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.025,
                        color: Colors.white,
                      ),
                      Container(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.025,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.02,
                    color: Colors.white,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Container(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.02,
                    color: Colors.white,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.02,
                    color: Colors.white,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.02,
                        color: Colors.white,
                      ),
                      Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.02,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: screenWidth * 0.5,
                          height: screenHeight * 0.02,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GenerateOrder {
  final String id;
  final String tblGenerateOrderLastId;
  final String clientNameId;
  final String orderId;
  final String productName;
  final String orderAmount;
  final String? updateOrderAmount;
  final String isDeleted;
  final String status;
  final String createdOn;
  final String updatedOn;
  final String clientName;
  final String itemGroup;
  final String branchName;
  final String orderDate;
  final String time;

  GenerateOrder({
    required this.id,
    required this.tblGenerateOrderLastId,
    required this.clientNameId,
    required this.orderId,
    required this.productName,
    required this.orderAmount,
    this.updateOrderAmount,
    required this.isDeleted,
    required this.status,
    required this.createdOn,
    required this.updatedOn,
    required this.clientName,
    required this.itemGroup,
    required this.branchName,
    required this.orderDate,
    required this.time,
  });

  factory GenerateOrder.fromJson(Map<String, dynamic> json) {
    return GenerateOrder(
      id: json['id'] ?? '', // Provide fallback values for nullable fields
      tblGenerateOrderLastId: json['tbl_generate_order_last_id'] ?? '',
      clientNameId: json['client_name_id'] ?? '',
      orderId: json['order_id'] ?? '',
      productName: json['product_name'] ?? '',
      orderAmount: json['order_amount'] ?? '',
      updateOrderAmount: json['update_order_amount'],
      isDeleted: json['is_deleted'] ?? '',
      status: json['status'] ?? '',
      createdOn: json['created_on'] ?? '',
      updatedOn: json['updated_on'] ?? '',
      clientName: json['client_name'] ?? '',
      itemGroup: json['item_group'] ?? '',
      branchName: json['branch_name'] ?? '',
      orderDate: json['order_date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
