import 'dart:convert';
import 'package:apparelapp/axonlibrary/axongeneral.dart';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/supplieroutstanding/purchase/purchaseordersummary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../axondatamodal/axonfitrationmodal/processoutstandingfilter.dart';
import '../../axondatamodal/processoutstandingmodal.dart';

class Purchasesummary extends StatefulWidget {
  const Purchasesummary({super.key});

  @override
  State<Purchasesummary> createState() => _PurchasesummaryState();
}

class _PurchasesummaryState extends State<Purchasesummary> {
  int listlength = 0;
  String status = "Wait fetching data...";
  final List<ProcessOutstandingModal> _itemlist = [];

  @override
  void initState() {
    super.initState();
    getsummarydetails();
  }

  @override
  void dispose() {
    super.dispose();
    _itemlist.clear();
  }

  Future<void> getsummarydetails() async {
    dynamic responsedata;
    var url =
        'http://${AppConfig().host}:${AppConfig().port}/api/apipurchaseoutstanding';
    var body = '''''';
    String length = body.length.toString();
    var header = {
      'Content-type': 'application/json',
      'Host': 'localhost',
      'User-Agent': 'PostmanRuntime/7.30.0',
      'Content-Length': length
    };

    try {
      var response = await http.get(Uri.parse(url), headers: header);

      // Print the response body for debugging
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // First, decode the outer array and extract the string inside
        List<dynamic> outerArray = jsonDecode(response.body);
        if (outerArray.isNotEmpty && outerArray[0] is String) {
          responsedata =
              jsonDecode(outerArray[0]); // Decode the inner JSON string

          // Process the decoded JSON list
          for (int i = 0; i < responsedata.length; i++) {
            var data = ProcessOutstandingModal.fromJson(responsedata[i]);
            _itemlist.add(data);
          }

          listlength = _itemlist.length;
          setState(() {
            listlength;
            _itemlist;
          });
        } else {
          print("Unexpected data format: $outerArray");
        }
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Purchase Outstanding Details',
          style: TextStyle(color: Color(0xFF0072FF)),
        ),
        leading: IconButton(
          color: Color(0xFF0072FF),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        itemCount: listlength,
        itemBuilder: ((context, index) {
          return Column(
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.purple,
                  ),
                  title: Text(
                    _itemlist[index].supplier.toString().toUpperCase(),
                  ),
                  trailing: Text(
                    '${_itemlist[index].balanceqty.toString()} ${_itemlist[index].outuom.toString()}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Po Quantity: ',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _itemlist[index].issueqty.toString(),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5), // Add spacing between the lines
                      Row(
                        children: [
                          Text(
                            'Received Qty: ',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _itemlist[index].receivedqty.toString(),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    int supplierId = _itemlist[index].supplierid ?? 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PurchaseOrderSummary(supplierId: supplierId),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
