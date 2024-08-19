import 'dart:convert';
import 'package:apparelapp/main/app_config.dart';
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

// New Page to replace the overlay
class ProcessProgramOverlayPage extends StatelessWidget {
  final ApiProcessPrgAppdetails cardData;

  ProcessProgramOverlayPage({required this.cardData});

  Future<List<ApiProcessPrgAppOverlayGrouped>> fetchOverlayData(
      int id, String approved) async {
    final response = await http.get(Uri.parse(
        'http://${AppConfig().host}:${AppConfig().port}/api/apiprocessprgappItem?id=$id&approved=$approved'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        final processprglist = data['processprglist'] as List;
        if (processprglist.isEmpty) {
          // Handle the case when no data is present
          print('No data available');
          return [];
        }
        final details = processprglist
            .map((item) => ApiProcessPrgAppOverlaydetails.fromJson(item))
            .toList();

        // Group by orderno
        final groupedData = <String, List<ApiProcessPrgAppOverlaydetails>>{};
        for (var detail in details) {
          if (!groupedData.containsKey(detail.prodPrgNo)) {
            groupedData[detail.prodPrgNo!] = [];
          }
          groupedData[detail.prodPrgNo!]!.add(detail);
        }

        return groupedData.entries
            .map((entry) => ApiProcessPrgAppOverlayGrouped(
                  orderno: entry.key,
                  details: entry.value,
                ))
            .toList();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to load overlay data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Process Program Details',
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
      body: FutureBuilder<List<ApiProcessPrgAppOverlayGrouped>>(
        future: fetchOverlayData(cardData.id, cardData.approved),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No details found.'));
          } else {
            return ListView(
              children: snapshot.data!.map((groupedItem) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProcessPrgAppEditPage(
                          prodprgid: groupedItem.details.first.prodprgid,
                        ),
                      ),
                    );
                  },
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
                          Text(
                            'Prod Prg No: ${groupedItem.orderno}',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...groupedItem.details.map((detail) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  'Process: ${detail.process}',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Program Date: ${detail.programDate}',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
