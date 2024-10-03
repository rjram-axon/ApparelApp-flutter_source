import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
import 'package:apparelapp/management/processprg_approvalOverlay.dart';
import 'package:apparelapp/management/processprgapproval_approve.dart';
import 'package:apparelapp/management/processprgapproval_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Define the ApiProcessPrgAppOverlaydetails class
class ApiProcessPrgAppOverlaydetails {
  final int prodprgid;
  final String? prodPrgNo;
  final String process;
  final String programDate;
  final String approved;

  ApiProcessPrgAppOverlaydetails({
    required this.prodprgid,
    this.prodPrgNo,
    required this.process,
    required this.programDate,
    required this.approved,
  });

  factory ApiProcessPrgAppOverlaydetails.fromJson(Map<String, dynamic> json) {
    return ApiProcessPrgAppOverlaydetails(
      prodprgid: json['ProdPrgid'],
      prodPrgNo: json['ProdPrgNo'],
      process: json['Process'],
      programDate: json['ProgramDate'],
      approved: json['Approved'],
    );
  }
}

// Define the ApiProcessPrgAppOverlayGrouped class
class ApiProcessPrgAppOverlayGrouped {
  final String orderno;
  final List<ApiProcessPrgAppOverlaydetails> details;

  ApiProcessPrgAppOverlayGrouped({
    required this.orderno,
    required this.details,
  });
}

// Main Stateful Widget
class ProcessProgramApprovalPage extends StatefulWidget {
  @override
  _ProcessProgramApprovalPageState createState() =>
      _ProcessProgramApprovalPageState();
}

class _ProcessProgramApprovalPageState
    extends State<ProcessProgramApprovalPage> {
  late Future<List<ApiProcessPrgAppdetails>> futureData;
  String approved = 'N'; // Default filter

  @override
  void initState() {
    super.initState();
    futureData = fetchApprovalData(approved);
  }

  // Fetch approval data based on 'approved' status
  Future<List<ApiProcessPrgAppdetails>> fetchApprovalData(
      String approved) async {
    final response = await http.get(Uri.parse(
        'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessprgapproval?approved=$approved'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        final allItems = (data['processprglist'] as List)
            .map((item) => ApiProcessPrgAppdetails.fromJson(item))
            .toList();

        // Remove duplicates based on 'orderno'
        final uniqueItems = <String, ApiProcessPrgAppdetails>{};
        for (var item in allItems) {
          uniqueItems[item.orderno] = item;
        }

        return uniqueItems.values.toList();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Handle filter change event
  void _onFilterChanged(String value) {
    setState(() {
      approved = value;
      futureData = fetchApprovalData(approved);
    });
  }

  // Navigate to overlay page for a selected card
  void _showOverlay(ApiProcessPrgAppdetails cardData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessProgramOverlayPage(
          cardData: cardData,
        ),
      ),
    ).then((refresh) {
      if (refresh != null && refresh) {
        setState(() {
          // Call your method to refresh data here
          futureData = fetchApprovalData(approved);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Shortage Approval',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _onFilterChanged('Y'),
                  style: ElevatedButton.styleFrom(
                    primary: approved == 'Y' ? Colors.green : Colors.grey[300],
                    onPrimary: approved == 'Y' ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Approved'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _onFilterChanged('N'),
                  style: ElevatedButton.styleFrom(
                    primary: approved == 'N' ? Colors.orange : Colors.grey[300],
                    onPrimary: approved == 'N' ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Pending'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ApiProcessPrgAppdetails>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue, // Choose your desired color
                      size: 50.0, // Set the size of the loading animation
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No Pending Process Program for Approval.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return GestureDetector(
                        onTap: () => _showOverlay(item),
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order No: ${item.orderno}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      item.approved == 'Y'
                                          ? Icons.check_circle
                                          : Icons.info,
                                      color: item.approved == 'Y'
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Ref No: ${item.refno}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Style: ${item.style}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Quantity: ${item.quantity}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
