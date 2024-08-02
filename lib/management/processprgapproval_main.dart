import 'dart:convert';
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
  bool isOverlayVisible = false; // To control overlay visibility
  ApiProcessPrgAppdetails? selectedCard; // Selected card data
  Future<List<ApiProcessPrgAppOverlayGrouped>>? overlayData; // Overlay data

  @override
  void initState() {
    super.initState();
    futureData = fetchApprovalData(approved);
  }

  // Fetch approval data based on 'approved' status
  Future<List<ApiProcessPrgAppdetails>> fetchApprovalData(
      String approved) async {
    final response = await http.get(Uri.parse(
        'http://13.232.84.26:81/api/apiprocessprgapproval?approved=$approved'));

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

  // Fetch overlay data for a selected card
  Future<List<ApiProcessPrgAppOverlayGrouped>> fetchOverlayData(
      int id, String approved) async {
    final response = await http.get(Uri.parse(
        'http://13.232.84.26:81/api/apiprocessprgappItem?id=$id&approved=$approved'));

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

  // Handle filter change event
  void _onFilterChanged(String value) {
    setState(() {
      approved = value;
      futureData = fetchApprovalData(approved);
    });
  }

  // Show overlay for a selected card
  void _showOverlay(ApiProcessPrgAppdetails cardData) {
    setState(() {
      isOverlayVisible = true;
      selectedCard = cardData;
      overlayData = fetchOverlayData(cardData.id, cardData.approved);
    });
  }

  // Hide overlay
  void _hideOverlay() {
    setState(() {
      isOverlayVisible = false;
      selectedCard = null;
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
      // Floating window overlay
      floatingActionButton: Visibility(
        visible: isOverlayVisible,
        child: Stack(
          children: [
            GestureDetector(
              onTap: _hideOverlay,
              child: Container(
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).size.height * 0.28,
              child: FutureBuilder<List<ApiProcessPrgAppOverlayGrouped>>(
                future: overlayData,
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
                    return Center(
                      child: Text(
                          'No overlay data found for the specified parameters.'),
                    );
                  } else {
                    return Column(
                      children: snapshot.data!.map((groupedItem) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey[200]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prod Prg No: ${groupedItem.orderno}',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                ...groupedItem.details.map((detail) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Process: ',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: detail.process,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Program Date: ',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: detail.programDate,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                                SizedBox(height: 30),
                                Align(
                                  alignment: Alignment.center,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProcessPrgAppEditPage(
                                            prodprgid: groupedItem
                                                .details.first.prodprgid,
                                          ),
                                        ),
                                      ); // Handle the button action here
                                    },
                                    child: Icon(Icons.add),
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height *
                        0.20), // Adjust this value to place the button higher
                child: FloatingActionButton(
                  onPressed: _hideOverlay,
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red, // Set the button color
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
