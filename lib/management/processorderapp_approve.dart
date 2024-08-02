import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

class ApparelProcOrdEditOutItemDet {
  final String prodPrgNo;
  final String jobOrdNo;
  final String item;
  final String color;
  final String size;
  final double progOpQty;
  final double rate;
  final double appRate;
  final String status;

  ApparelProcOrdEditOutItemDet({
    required this.prodPrgNo,
    required this.jobOrdNo,
    required this.item,
    required this.color,
    required this.size,
    required this.progOpQty,
    required this.rate,
    required this.appRate,
    required this.status,
  });

  factory ApparelProcOrdEditOutItemDet.fromJson(Map<String, dynamic> json) {
    return ApparelProcOrdEditOutItemDet(
      prodPrgNo: json['ProdPrgNo'],
      jobOrdNo: json['Job_ord_no'],
      item: json['item'],
      color: json['color'],
      size: json['size'],
      progOpQty: json['prog_op_qty'].toDouble(),
      rate: json['rate'].toDouble(),
      appRate: json['AppRate'].toDouble(),
      status: json['Approved'],
    );
  }
}

class ApiService {
  final String baseUrl =
      'http://13.232.84.26:8101/api/appparelprocordereditoutitemdet';

  Future<List<ApparelProcOrdEditOutItemDet>> fetchProcOrders(int procid) async {
    final response = await http.get(Uri.parse('$baseUrl?procid=$procid'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data
          .map((item) => ApparelProcOrdEditOutItemDet.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateProcessApproval(String processorder, String status) async {
    final url =
        'http://13.232.84.26:8101/api/updateprocessapproval/$processorder';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isApproved': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update process approval');
    }
  }
}

class ProcOrderListScreen extends StatefulWidget {
  final int procid;
  final String processorder;
  final VoidCallback onApprovalUpdate;

  ProcOrderListScreen({
    required this.procid,
    required this.processorder,
    required this.onApprovalUpdate,
  });

  @override
  _ProcOrderListScreenState createState() => _ProcOrderListScreenState();
}

class _ProcOrderListScreenState extends State<ProcOrderListScreen> {
  late Future<List<ApparelProcOrdEditOutItemDet>> futureProcOrders;

  @override
  void initState() {
    super.initState();
    futureProcOrders = ApiService().fetchProcOrders(widget.procid);
  }

  Flushbar? flushbarMessage;

  void _showFlushbar(String message, Color backgroundColor, IconData iconData) {
    flushbarMessage?.dismiss();
    flushbarMessage = Flushbar(
      message: message,
      duration: Duration(seconds: 1),
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(10.0),
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 10.0,
          spreadRadius: 1.0,
          offset: Offset(0.0, 3.0),
        ),
      ],
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: backgroundColor,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  Future<void> _updateApprovalStatus(String status) async {
    try {
      List<ApparelProcOrdEditOutItemDet> items = await futureProcOrders;

      // Filter items based on the desired status
      List<ApparelProcOrdEditOutItemDet> filteredItems = items.where((item) {
        if (status == 'A') {
          return item.status == 'P';
        } else if (status == 'P') {
          return item.status == 'A';
        }
        return false;
      }).toList();

      for (var item in filteredItems) {
        await ApiService().updateProcessApproval(widget.processorder, status);
      }

      setState(() {
        futureProcOrders = ApiService().fetchProcOrders(widget.procid);
      });
      Color flushbarColor = status == 'A' ? Colors.green : Colors.red;
      IconData flushbarIcon = status == 'A' ? Icons.check_circle : Icons.error;
      String flushbarMessage = status == 'A'
          ? 'All Process have been Approved'
          : 'All Process have been Rejected';

      _showFlushbar(
        flushbarMessage,
        flushbarColor,
        flushbarIcon,
      );

      // Invoke the callback to refresh data on the main page
      widget.onApprovalUpdate();

      // Navigate back to the main page
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    } catch (e) {
      _showFlushbar(
        'Failed to update process approval',
        Colors.red,
        Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proc Order List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ApparelProcOrdEditOutItemDet>>(
              future: futureProcOrders,
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
                  return Center(child: Text('No data found'));
                } else {
                  // Determine if there are any pending or approved items
                  bool hasPending =
                      snapshot.data!.any((item) => item.status == 'P');
                  bool hasApproved =
                      snapshot.data!.any((item) => item.status == 'A');

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ExpansionTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.item,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              'Color: ${item.color}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Size: ${item.size}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Quantity: ${item.progOpQty}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Rate: ${item.rate}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Approved Rate: ${item.appRate}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: Icon(
                                    Icons.add_to_photos_rounded,
                                    color: Colors.blue[800],
                                  ),
                                  trailing: SizedBox.shrink(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (hasPending)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: ElevatedButton(
                            onPressed: () => _updateApprovalStatus('A'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: Text('Approve'),
                          ),
                        ),
                      if (hasApproved)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: ElevatedButton(
                            onPressed: () => _updateApprovalStatus('P'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: Text('Reject'),
                          ),
                        ),
                    ],
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
