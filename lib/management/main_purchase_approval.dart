import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/purchase_approval_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../axonlibrary/axongeneral.dart';
import 'purchase_order.dart'; // Add this import statement

class MainPurchaseApproval extends StatefulWidget {
  @override
  _MainPurchaseApprovalState createState() => _MainPurchaseApprovalState();
}

class _MainPurchaseApprovalState extends State<MainPurchaseApproval> {
  List<PurchaseOrder> orders = [];
  List<String> uniquePOs = [];
  String selectedFilter = 'Pending'; // Default filter
  int approvedCount = 0;
  int pendingCount = 0;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchCounts(); // Fetch counts for both filters
    fetchData(selectedFilter); // Fetch data based on the default filter
  }

  Future<void> fetchData(String filter) async {
    setState(() {
      isLoading = true; // Start loading
      orders.clear(); // Clear the orders list before fetching new data
      uniquePOs.clear(); // Clear the unique POs list
    });

    final approvalStatus = filter == 'Approved' ? 'Y' : 'N';
    final url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseapproval?isapproved=$approvalStatus';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> purchases = responseData['purchases'];

        for (var purchaseData in purchases) {
          PurchaseOrder purchaseOrder = PurchaseOrder(
            orderNo: purchaseData['OrderNo'] ?? '',
            purOrdId: purchaseData['PurOrdId'],
            purOrdNo: purchaseData['PO_Number'],
            item: purchaseData['Item'],
            style: purchaseData['Style'] ?? '',
            color: purchaseData['Colour'] ?? '',
            reference: purchaseData['Reference'],
            orderDate: DateTime.parse(purchaseData['OrderDate']),
            quantity: purchaseData['Quantity'].toDouble(),
            rate: purchaseData['Rate'].toDouble(),
            totalAmount: purchaseData['TotalAmount'].toDouble(),
            supplier: purchaseData['Supplier'],
            approved: purchaseData['IsApproved'],
          );

          orders.add(purchaseOrder);

          if (!uniquePOs.contains(purchaseOrder.purOrdNo)) {
            uniquePOs.add(purchaseOrder.purOrdNo);
          }
        }

        // Update filter counts
        updateFilterCounts();
        // Fetch counts for both filters
        fetchCounts();

        if (orders.isEmpty) {
          // Show error message if no data is found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No $filter orders found.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error fetching data. Please try again.'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> fetchCounts() async {
    final approvedUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseapproval?isapproved=Y';
    final pendingUrl =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseapproval?isapproved=N';

    try {
      final approvedResponse = await http.get(Uri.parse(approvedUrl));
      final pendingResponse = await http.get(Uri.parse(pendingUrl));

      if (approvedResponse.statusCode == 200 &&
          pendingResponse.statusCode == 200) {
        final List<dynamic> approvedPurchases =
            jsonDecode(approvedResponse.body)['purchases'];
        final List<dynamic> pendingPurchases =
            jsonDecode(pendingResponse.body)['purchases'];

        final Set<String> approvedPOs = approvedPurchases
            .map((purchase) => purchase['PO_Number'] as String)
            .toSet();

        final Set<String> pendingPOs = pendingPurchases
            .map((purchase) => purchase['PO_Number'] as String)
            .toSet();

        setState(() {
          approvedCount = approvedPOs.length;
          pendingCount = pendingPOs.length;
        });
      } else {
        throw Exception('Failed to load counts');
      }
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  void updateFilterCounts() {
    Set<String> uniquePONumbers = Set.from(uniquePOs);

    approvedCount = uniquePONumbers.where((poNumber) {
      return orders
          .any((order) => order.purOrdNo == poNumber && order.approved == 'Y');
    }).length;

    pendingCount = uniquePONumbers.where((poNumber) {
      return orders
          .any((order) => order.purOrdNo == poNumber && order.approved == 'N');
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'PurchaseOrder Approval List',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          color: Colors.teal,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = 'Approved';
                    fetchData(
                        selectedFilter); // Fetch data based on the selected filter
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      selectedFilter == 'Approved' ? Colors.green : Colors.grey,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Approved ($approvedCount)'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = 'Pending';
                    fetchData(
                        selectedFilter); // Fetch data based on the selected filter
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      selectedFilter == 'Pending' ? Colors.orange : Colors.grey,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Pending ($pendingCount)'),
              ),
            ],
          ),
          // Orders
          Expanded(
            child: isLoading
                ? Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue, // Choose your desired color
                      size: 50.0, // Set the size of the loading animation
                    ), // Loading indicator
                  )
                : orders.isEmpty
                    ? Center(
                        child: Text(
                          'No $selectedFilter orders found.',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: uniquePOs.length,
                        itemBuilder: (context, index) {
                          final poNumber = uniquePOs[index];
                          final poOrders = orders
                              .where((order) => order.purOrdNo == poNumber)
                              .toList();
                          final order = poOrders.first;

                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                "PO No: ${order.purOrdNo}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    "Order Date: ${order.orderDate.toString().substring(0, 10)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Reference: ${order.reference != null && order.reference.length >= 10 ? order.reference.substring(0, 10) : order.reference}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Supplier: ${order.supplier}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PurchaseOrderDetail(
                                      poNumber: order.purOrdNo,
                                      orders: orders,
                                      onApprovalStatusChanged:
                                          (orderNo, status) {
                                        _handleApprovalStatusChange(
                                            orderNo, status);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _handleApprovalStatusChange(String orderNo, String status) {
    setState(() {
      orders
          .where((order) => order.purOrdNo == orderNo)
          .forEach((order) => order.approved = status);
      updateFilterCounts(); // Update counts after approval status changes
    });
  }
}
