import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/supplieroutstanding/purchase/purchaseorderjson.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PurchaseOrderDetailsPage extends StatefulWidget {
  final String poId;

  const PurchaseOrderDetailsPage({Key? key, required this.poId})
      : super(key: key);

  @override
  _PurchaseOrderDetailsPageState createState() =>
      _PurchaseOrderDetailsPageState();
}

class _PurchaseOrderDetailsPageState extends State<PurchaseOrderDetailsPage> {
  late Future<List<PurchaseOrder>> _futurePurchaseOrders;

  @override
  void initState() {
    super.initState();
    _futurePurchaseOrders = fetchPurchaseOrders(widget.poId);
  }

  Future<List<PurchaseOrder>> fetchPurchaseOrders(String poId) async {
    final response = await http.get(Uri.parse(
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseoutorderdetails?ponumber=${poId}'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        final List purchases = jsonResponse['purchases'];
        return purchases.map((json) => PurchaseOrder.fromJson(json)).toList();
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to load purchase orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Purchase OutstandingOrder Details',
          style: TextStyle(color: Color(0xFF0072FF)),
        ),
        leading: IconButton(
          color: Color(0xFF0072FF),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: FutureBuilder<List<PurchaseOrder>>(
        future: _futurePurchaseOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No purchase orders found.'));
          }

          final List<PurchaseOrder> purchaseOrders = snapshot.data!;

          return ListView.builder(
            itemCount: purchaseOrders.length,
            itemBuilder: (context, index) {
              final purchaseOrder = purchaseOrders[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    "Order No: ${purchaseOrder.orderNo}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Order Date: ${purchaseOrder.orderDate.substring(0, 10)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Reference: ${purchaseOrder.reference.length >= 10 ? purchaseOrder.reference.substring(0, 10) : purchaseOrder.reference}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Supplier: ${purchaseOrder.supplier}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Item: ${purchaseOrder.item}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
