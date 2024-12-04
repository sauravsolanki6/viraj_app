import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:viraj_application/generate_order_list.dart';

class GenerateOrderPage extends StatefulWidget {
  @override
  _GenerateOrderPageState createState() => _GenerateOrderPageState();
}

class _GenerateOrderPageState extends State<GenerateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  String? _selectedItemGroup;
  String? _selectedBranchId;
  String? BranchId;
  List<String> selectedProductIds = [];
  Map<String, String> _productNameToId = {};

  String _branchName = '';
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, String>> _products = [
    {'productName': '', 'orderQuantity': ''}
  ];
  List<String> _itemGroups = [];
  List<String> _branches = [];
  List<String> _productNames = [];
  List<Map<String, String>> _addedProducts =
      []; // List to hold added products and quantities

  TextEditingController _orderPlanQuantityController = TextEditingController();
  TextEditingController _productController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _sendOrderRequest(
      Map<String, dynamic> orderData, BuildContext context) async {
    final url =
        'https://staginglink.org/viraj_techplast/set_generate_order_api';

    try {
      // Print the request body
      print('Request Body: ${json.encode(orderData)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(orderData),
      );

      // Print the response body
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'true') {
          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent closing by tapping outside
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text('Success'),
                  ],
                ),
                content: Text('Order Generated Successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersScreen(),
                        ),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show error message if status is not true
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to generate order: ${responseBody['message']}'),
            ),
          );
        }
      } else {
        // Handle server errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }

  Future<void> _fetchClients() async {
    const url = 'https://staginglink.org/viraj_techplast/get_all_clients';
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "true" && data['data'] is List) {
          setState(() {
            _clients = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          _showError('Invalid data format');
        }
      } else {
        _showError('Failed to load clients: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error fetching clients: $e');
    }
  }

  Future<void> _fetchProducts(
      String clientId, String itemGroup, String branchId) async {
    const url = 'https://staginglink.org/viraj_techplast/get_products_api';
    try {
      final requestBody = jsonEncode({
        'client_id': clientId,
        'item_group': itemGroup,
        'branch_name': BranchId,
      });

      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "true" && data['data'] is List) {
          final productsData = List<Map<String, dynamic>>.from(data['data']);

          // Create a map to store product names and their IDs
          Map<String, String> productNameToId = {};

          for (var product in productsData) {
            if (product['product_name'] != null && product['id'] != null) {
              // Store the product name and its ID
              productNameToId[product['product_name']] =
                  product['id'].toString();
            }
          }

          setState(() {
            _productNames = productNameToId.keys.toList();
            _productNameToId = productNameToId;
          });
        } else {
          _showError('Invalid data format for products');
        }
      } else {
        _showError('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error fetching products: $e');
    }
  }

  Future<void> _fetchBranchesAndItemGroups(String clientId) async {
    const url = 'https://staginglink.org/viraj_techplast/get_client_branch_api';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'client_id': clientId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "true" && data['data'] is List) {
          final branchesData = List<Map<String, dynamic>>.from(data['data']);
          Set<String> itemGroupsSet = {};
          Set<String> branchesSet = {};

          if (branchesData.isNotEmpty) {
            BranchId = branchesData[0]['id'].toString();
          }

          for (var branch in branchesData) {
            if (branch['branch_name'] != null) {
              branchesSet.add(branch['branch_name']);
            }
            if (branch['item_group'] != null) {
              branch['item_group'].split(',').forEach((itemGroup) {
                itemGroupsSet.add(itemGroup.trim());
              });
            }
          }

          setState(() {
            _branches = branchesSet.toList();
            _itemGroups = itemGroupsSet.toList();
          });
        } else {
          _showError('Invalid data format for branches');
        }
      } else {
        _showError('Failed to load branches: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error fetching branches: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _addProduct() {
    if (_productController.text.isNotEmpty &&
        _orderPlanQuantityController.text.isNotEmpty) {
      setState(() {
        // Retrieve the product ID from the mapping using the selected product name
        String productId = _productNameToId[_productController.text] ?? '';
        if (productId.isNotEmpty) {
          _addedProducts.add({
            'productName': _productController.text,
            'orderQuantity': _orderPlanQuantityController.text,
            'productId': productId, // Store the product ID
          });
          selectedProductIds.add(productId); // Add the product ID to the list
        } else {
          _showError('Selected product does not have a valid ID');
        }
        _productController.clear();
        _orderPlanQuantityController.clear();
      });
    } else {
      _showError('Please enter both product and quantity');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _availableProductNames = _productNames.where((productName) {
      return !_addedProducts
          .any((addedProduct) => addedProduct['productName'] == productName);
    }).toList();
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04;
    double fontSizeTitle = screenWidth * 0.06;
    double fontSizeLabel = screenWidth * 0.045;
    double fontSizeButton = screenWidth * 0.04;

    return WillPopScope(
      onWillPop: () async {
        // Navigate to SDateTime when back button is pressed
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersScreen(),
          ),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Generate Order', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFFCC332B),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdersScreen(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Details',
                      style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: padding),
                  DropdownButtonFormField<String>(
                    value: _selectedClientId,
                    decoration: InputDecoration(
                      labelText: 'Client Name *',
                      border: OutlineInputBorder(),
                    ),
                    items: _clients.map((client) {
                      return DropdownMenuItem<String>(
                        value: client['id'].toString(),
                        child: Text(client['client_name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedClientId = value;
                        _selectedItemGroup = null;
                        _branchName = '';
                        _itemGroups = [];
                        _branches = [];
                        _productNames = [];
                        _addedProducts
                            .clear(); // Clear products list when client changes
                        if (_selectedClientId != null) {
                          _fetchBranchesAndItemGroups(_selectedClientId!);
                        }
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Client Name is required' : null,
                  ),
                  SizedBox(height: padding),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Item Group *',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedItemGroup,
                    items: _itemGroups.map((group) {
                      return DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItemGroup = value;
                        if (_selectedClientId != null &&
                            _selectedItemGroup != null) {
                          _fetchProducts(_selectedClientId!,
                              _selectedItemGroup!, _branchName);
                        }
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Item Group is required' : null,
                  ),
                  SizedBox(height: padding),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Branch Name *',
                      border: OutlineInputBorder(),
                    ),
                    value: _branchName.isEmpty ? null : _branchName,
                    items: _branches.map((branch) {
                      return DropdownMenuItem<String>(
                        value: branch,
                        child: Text(branch),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _branchName = value ?? '';
                        if (_selectedClientId != null &&
                            _selectedItemGroup != null) {
                          _fetchProducts(_selectedClientId!,
                              _selectedItemGroup!, _branchName);
                        }
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Branch Name is required'
                        : null,
                  ),
                  SizedBox(height: padding),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Date', border: OutlineInputBorder()),
                    controller: TextEditingController(text: currentDate),
                    readOnly: true,
                  ),
                  SizedBox(height: padding),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Time', border: OutlineInputBorder()),
                    controller: TextEditingController(text: currentTime),
                    readOnly: true,
                  ),
                  SizedBox(height: padding),
                  Text('Products',
                      style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: padding),
                  _productNames.isNotEmpty
                      ? Column(
                          children: [
                            // Update the dropdown to use the filtered list
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Product',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      3), // Sharp edges with a small radius
                                  borderSide: BorderSide(
                                    color: Colors.blue, // Border color
                                    width: 2, // Border width
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8), // Padding inside the field
                                labelStyle: TextStyle(
                                  color: Colors.blue, // Label color
                                  fontWeight: FontWeight.bold, // Label weight
                                ),
                              ),
                              value: _availableProductNames
                                      .contains(_productController.text)
                                  ? _productController.text
                                  : null, // Set value if it exists in the list
                              items: _availableProductNames
                                  .toSet()
                                  .map((productName) {
                                return DropdownMenuItem<String>(
                                  value: productName,
                                  child: Text(
                                    productName,
                                    style: TextStyle(
                                      fontSize: 16, // Text size
                                      color: Colors.black, // Text color
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _productController.text = value ??
                                      ''; // Update the controller text with the selected value
                                });
                              },
                              dropdownColor: Colors
                                  .white, // Background color of the dropdown
                              style: TextStyle(
                                color: Colors
                                    .black, // Text color of the selected item
                                fontSize: 16, // Font size of the selected item
                              ),
                              isExpanded:
                                  true, // Ensures the dropdown is expanded to fit the width of the form
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _orderPlanQuantityController,
                              decoration: InputDecoration(
                                  labelText: 'Order Plan Quantity',
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Order Plan Quantity is required';
                              //   }
                              //   if (int.tryParse(value) == null) {
                              //     return 'Enter a valid number';
                              //   }
                              //   return null;
                              // },
                            ),
                            ElevatedButton(
                              onPressed: _addProduct,
                              child: Text('Add Product'),
                            ),
                          ],
                        )
                      : Center(child: Text('No products available')),
                  SizedBox(height: padding),
                  // Text('Added Products:',
                  //     style: TextStyle(
                  //         fontSize: fontSizeTitle, fontWeight: FontWeight.bold)),
                  _addedProducts.isNotEmpty
                      ? Column(
                          children: _addedProducts.map((product) {
                            return ListTile(
                              title: Text('Product: ${product['productName']}'),
                              subtitle:
                                  Text('Quantity: ${product['orderQuantity']}'),
                            );
                          }).toList(),
                        )
                      : Center(child: Text('')),
                  SizedBox(height: padding),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity, // Full width of the screen
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0), // Optional padding
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Check if there are any products in the input fields that aren't already in _addedProducts
                            if (_productController.text.isNotEmpty &&
                                _orderPlanQuantityController.text.isNotEmpty) {
                              // Add the product and quantity if not already added
                              String productId =
                                  _productNameToId[_productController.text] ??
                                      '';
                              if (productId.isNotEmpty) {
                                // Check if the product is already added
                                bool productAlreadyAdded = _addedProducts.any(
                                    (product) =>
                                        product['productId'] == productId);
                                if (!productAlreadyAdded) {
                                  _addedProducts.add({
                                    'productName': _productController.text,
                                    'orderQuantity':
                                        _orderPlanQuantityController.text,
                                    'productId': productId,
                                  });
                                }
                              }
                            }

                            // Collect product IDs and quantities directly from user input
                            List<String> productIds = [];
                            List<String> quantities = [];

                            for (var product in _addedProducts) {
                              productIds
                                  .add(product['productId']!); // Add product ID
                              quantities.add(product[
                                  'orderQuantity']!); // Add order quantity
                            }

                            if (productIds.isEmpty) {
                              _showError(
                                  'No products have been added to the order');
                              return;
                            }

                            // Create the order data map
                            Map<String, dynamic> _orderData = {
                              'client_name': _selectedClientId,
                              'item_group': _selectedItemGroup,
                              'branch_name': BranchId,
                              'order_date': currentDate,
                              'time': currentTime,
                              'product_name': productIds,
                              'order_amount': quantities,
                            };

                            // Print the collected data
                            print('Order Data: $_orderData');

                            // Call the API with the collected data
                            _sendOrderRequest(_orderData, context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Set the background color to red
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0), // Adjust padding for size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Optional rounded corners
                          ),
                        ),
                        child: Text(
                          'Generate Order',
                          style: TextStyle(
                            fontSize:
                                20.0, // Adjust the font size for better visibility
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
