import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/supplieroutstanding/productionoutstandingmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductionOutstanding extends StatefulWidget {
  const ProductionOutstanding({super.key});

  @override
  State<ProductionOutstanding> createState() => _ProductionOutstandingState();
}

class _ProductionOutstandingState extends State<ProductionOutstanding> {
  final Map<String, Map<String, Map<String, ProductionOutstandingModal>>>
      _groupedItems = {};
  String status = "Fetching data...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getOutstandingDetails();
  }

  @override
  void dispose() {
    _groupedItems.clear();
    super.dispose();
  }

  Future<void> getOutstandingDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      var url =
          'http://${AppConfig().host}:${AppConfig().port}/api/apiproductionoutstanding';
      var headers = {
        'Content-Type': 'application/json',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          List data = responseData['productions'];

          _groupedItems.clear(); // Clear previous data

          for (var item in data) {
            var production = ProductionOutstandingModal.fromJson(item);
            String cuttingOrderNo = production.cuttingOrderNo ?? 'Unknown';
            String dcNo = production.dcNo ?? 'Unknown DC No';
            String supplier = production.supplier ?? 'Unknown Supplier';

            // Group by cuttingOrderNo
            if (!_groupedItems.containsKey(cuttingOrderNo)) {
              _groupedItems[cuttingOrderNo] = {};
            }

            // Group by dcNo within the cuttingOrderNo
            if (!_groupedItems[cuttingOrderNo]!.containsKey(dcNo)) {
              _groupedItems[cuttingOrderNo]![dcNo] = {};
            }

            // Group by supplier within the dcNo
            if (!_groupedItems[cuttingOrderNo]![dcNo]!.containsKey(supplier)) {
              // Add a new supplier entry
              _groupedItems[cuttingOrderNo]![dcNo]![supplier] = production;
            } else {
              // If the supplier already exists, sum the quantities
              var existingProduction =
                  _groupedItems[cuttingOrderNo]![dcNo]![supplier];

              existingProduction!.orderQty =
                  (existingProduction.orderQty ?? 0) +
                      (production.orderQty ?? 0);
              existingProduction.issuedqty =
                  (existingProduction.issuedqty ?? 0) +
                      (production.issuedqty ?? 0);

              // Debugging logs
              // print(
              //     "Supplier: $supplier, Updated Order Qty: ${existingProduction.orderQty}");
              // print(
              //     "Supplier: $supplier, Updated Issued Qty: ${existingProduction.issuedqty}");
            }
          }

          if (mounted) {
            setState(() {
              status = _groupedItems.isEmpty
                  ? "No outstanding productions found"
                  : "Production Outstanding List";
              isLoading = false;
            });
          }
        } else {
          setState(() {
            status = responseData['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          status = "Failed to fetch data: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        status = "Error occurred: $e";
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
          'Production Outstanding',
          style: TextStyle(color: Color(0xFF0072FF)),
        ),
        leading: IconButton(
          color: const Color(0xFF0072FF),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _groupedItems.isNotEmpty
              ? ListView.builder(
                  itemCount: _groupedItems.length,
                  itemBuilder: (context, index) {
                    String cuttingOrderNo = _groupedItems.keys.elementAt(index);
                    Map<String, Map<String, ProductionOutstandingModal>>
                        dcGroups = _groupedItems[cuttingOrderNo]!;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the group title (cuttingOrderNo)
                            Text(
                              'Order: $cuttingOrderNo',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Display each DC group within the cutting order
                            ...dcGroups.entries.map((dcEntry) {
                              String dcNo = dcEntry.key;
                              Map<String, ProductionOutstandingModal>
                                  suppliers = dcEntry.value;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DC NO: $dcNo',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    // Display each supplier within the DC group
                                    ...suppliers.entries.map((supplierEntry) {
                                      ProductionOutstandingModal supplierData =
                                          supplierEntry.value;

                                      // Calculate the balance qty
                                      double balanceQty =
                                          (supplierData.issuedqty ?? 0) -
                                              (supplierData.recptQty ?? 0);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Supplier name
                                                Text(
                                                  supplierData.supplier!
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // Balance Qty in red on the right
                                                Text(
                                                  '${balanceQty.toStringAsFixed(2)} ${supplierData.recptUom}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Display orderQty, issuedQty, and style below the supplier name
                                            Text(
                                              'Issued Qty: ${supplierData.issuedqty?.toStringAsFixed(2) ?? "0"} ${supplierData.issueUom}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Receipt Qty: ${supplierData.recptQty?.toStringAsFixed(2) ?? "0"} ${supplierData.recptUom}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
    );
  }
}
