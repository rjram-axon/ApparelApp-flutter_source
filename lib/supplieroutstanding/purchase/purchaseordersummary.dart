import 'package:apparelapp/supplieroutstanding/purchase/purchaseoutorderdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart'; // Required for groupBy function
import 'package:apparelapp/main/app_config.dart';

class PurchaseOrderSummary extends StatefulWidget {
  final int supplierId;

  const PurchaseOrderSummary({Key? key, required this.supplierId})
      : super(key: key);

  @override
  State<PurchaseOrderSummary> createState() => _PurchaseOrderSummaryState();
}

class _PurchaseOrderSummaryState extends State<PurchaseOrderSummary> {
  Map<String, List<dynamic>> groupedPurchaseOrders = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPurchaseOrders();
  }

  Future<void> fetchPurchaseOrders() async {
    final url = Uri.parse(
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseoutstandingdetails?Supplierid=${widget.supplierId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            List<dynamic> purchases = data['purchases'] ?? [];
            // Group purchases by PO_Number
            groupedPurchaseOrders = groupBy(purchases,
                (purchase) => purchase['PO_Number'] ?? 'No Order No');
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load data';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Purchase Order Summary',
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          color: Colors.teal,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : groupedPurchaseOrders.isEmpty
                  ? const Center(child: Text('No data available'))
                  : ListView.builder(
                      itemCount: groupedPurchaseOrders.length,
                      itemBuilder: (context, index) {
                        // Get the current group (PO_Number and list of orders)
                        String poNumber =
                            groupedPurchaseOrders.keys.elementAt(index);
                        List<dynamic> orders = groupedPurchaseOrders[poNumber]!;

                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
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
                              'PO Number: $poNumber',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: orders.map((order) {
                                final item = order['Item'] ?? '';
                                final supplier =
                                    order['Supplier'] ?? 'Unknown Supplier';
                                final receivedQty =
                                    order['Receivedquantity']?.toString() ??
                                        '0';
                                final balanceQty =
                                    order['Balancequantity']?.toString() ?? '0';

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Item: $item'),
                                      Text('Supplier: $supplier'),
                                      Text('Received Qty: $receivedQty'),
                                      Text('Balance Qty: $balanceQty'),
                                      const Divider(),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            onTap: () {
                              // Navigate to PurchaseOrderDetailsPage when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PurchaseOrderDetailsPage(poId: poNumber),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
